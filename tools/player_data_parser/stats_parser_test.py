"""A unittest for the stats_parser module.
"""

__author__ = 'akshaylal@gmail.com'

import logging
import re

import mox
import unittest

import stats_parser


class PlayerDataParserTest(unittest.TestCase):

  def setUp(self):
    self.mox = mox.Mox()
    self.fake_data = 'fake-data'
    self.fake_team_name = 'a-fake-team'
    self.fake_team_id = 42

  def tearDown(self):
    pass

  def testParseTeamStatsPass(self):
    fake_stats_1 = (
        ' , [[23,\'a fake team\',.76,[[[\'fake_stat\',[3]],')
    fake_stats_2 = (
        ',[42,\'another fake team\',.76,[[[\'fake_stat\',[3]],')

    self.mox.ReplayAll()
    data_parser = stats_parser.PlayerDataParser(self.fake_data)

    team_id, team_name = data_parser._ParseTeamStats(fake_stats_1)
    self.assertEquals(23, team_id)
    self.assertEquals('a fake team', team_name)

    team_id, team_name = data_parser._ParseTeamStats(fake_stats_2)
    self.assertEquals(42, team_id)
    self.assertEquals('another fake team', team_name)

  def testParseTeamStatsFail(self):
    fake_stats = (
        '23,\'a fake team\',.76,[[[\'fake_stat\',[3]],')

    self.mox.ReplayAll()
    data_parser = stats_parser.PlayerDataParser(self.fake_data)

    self.assertRaises(ValueError, data_parser._ParseTeamStats, fake_stats)

  def testParsePlayerStatsPassPlayed(self):
    fake_stats = (
        '[1234,\'mighty mouse\',1.2,[[[\'goals_scored\',[\"1\"]],'
        '[\'goals_conceded\',[\"0\"]],'
        '[\'position\',[\'FW\']]]],5,\'FW\',32,0,0,\'FW\',10,11,12]')

    self.mox.ReplayAll()
    data_parser = stats_parser.PlayerDataParser(self.fake_data)
    self.assertTrue(data_parser._ParsePlayerStats(
        fake_stats, self.fake_team_id, self.fake_team_name))

    # Lets verify that the map got updated accurately.
    self.assertEquals(1, len(data_parser.player_stats_map))

    # Player id.
    self.assertEquals([1234], data_parser.player_stats_map.keys())
    # Total entries in player_stats_map.
    self.assertEquals(8, len(data_parser.player_stats_map[1234]))
    # Player team name.
    self.assertEquals(self.fake_team_name,
                      data_parser.player_stats_map[1234]['team_name'])
    # Player team id.
    self.assertEquals(self.fake_team_id,
                      data_parser.player_stats_map[1234]['team_id'])
    # Player name.
    self.assertEquals('mighty mouse',
                      data_parser.player_stats_map[1234]['name'])
    # Player position.
    self.assertEquals('FW',
                      data_parser.player_stats_map[1234]['position'])
    # Player minutes played.
    self.assertEquals(90,
                      data_parser.player_stats_map[1234]['mins_played'])
    # Player shirt number.
    self.assertEquals(32,
                      data_parser.player_stats_map[1234]['shirt_number'])
    # Player stats.
    self.assertEquals('0',
                      data_parser.player_stats_map[1234]['goals_conceded'])
    self.assertEquals('1',
                      data_parser.player_stats_map[1234]['goals_scored'])
    self.mox.VerifyAll()

#  def testParsePlayerStatsPassNameInDoubleQuotes(self):
#    fake_stats = (
#        '[1234,"mighty mouse",1.2,[[[\'size\',[\"123\"]],[\'model\',[456]],'
#        '[\'position\'],[\'FW\'],\'mouse\'')
#
#    self.mox.ReplayAll()
#    data_parser = stats_parser.PlayerDataParser(self.fake_data)
#    self.assertTrue(data_parser._ParsePlayerStats(fake_stats))
#
#    # Lets verify that the map got updated accurately.
#    self.assertEquals(1, len(data_parser.player_stats_map))
#    self.assertEquals([1234], data_parser.player_stats_map.keys())
#    self.assertEquals(4, len(data_parser.player_stats_map[1234]))
#    self.assertEquals('mighty mouse',
#                      data_parser.player_stats_map[1234]['name'])
#    self.assertEquals('123',
#                      data_parser.player_stats_map[1234]['size'])
#    self.assertEquals('456',
#                      data_parser.player_stats_map[1234]['model'])
#    self.assertEquals('FW',
#                      data_parser.player_stats_map[1234]['position'])
#
#    self.mox.VerifyAll()
#
#  def testParsePlayerStatsPassSpacesBetweenElements(self):
#    fake_stats = (
#        '[1234, "mighty mouse", 1.2,[[[\'size\', [123]],[\'model\',[456]],'
#        '[\'position\'],[\'FW\'],\'mouse\'')
#
#    self.mox.ReplayAll()
#    data_parser = stats_parser.PlayerDataParser(self.fake_data)
#    self.assertTrue(data_parser._ParsePlayerStats(fake_stats))
#
#    # Lets verify that the map got updated accurately.
#    self.assertEquals(1, len(data_parser.player_stats_map))
#    self.assertEquals([1234], data_parser.player_stats_map.keys())
#    self.assertEquals(4, len(data_parser.player_stats_map[1234]))
#    self.assertEquals('mighty mouse',
#                      data_parser.player_stats_map[1234]['name'])
#    self.assertEquals('123',
#                      data_parser.player_stats_map[1234]['size'])
#    self.assertEquals('456',
#                      data_parser.player_stats_map[1234]['model'])
#    self.assertEquals('FW',
#                      data_parser.player_stats_map[1234]['position'])
#
#    self.mox.VerifyAll()
#
#  def testParsePlayerStatsPassSubstituePlayers(self):
#    fake_stats = (
#        '[1234, "mighty mouse", 1.2,[[[\'position\', [\"SUB\"]],[\'mod\',[6]]'
#        '\'mouse\'')
#
#    self.mox.ReplayAll()
#    data_parser = stats_parser.PlayerDataParser(self.fake_data)
#    self.assertTrue(data_parser._ParsePlayerStats(fake_stats))
#
#    # Lets verify that the map got updated accurately. The sub player should
#    # not be added.
#    self.assertEquals(1, len(data_parser.player_stats_map))
#    self.assertEquals('mighty mouse',
#                      data_parser.player_stats_map[1234]['name'])
#    self.assertEquals('SUB',
#                      data_parser.player_stats_map[1234]['position'])
#
#    self.mox.VerifyAll()
#
#  def testParsePlayerStatsPassNoPositionData(self):
#    fake_stats = (
#        '[1234, "mighty mouse", 1.2,[[[\'mod\',[6]],\'mouse\'')
#
#    self.mox.ReplayAll()
#    data_parser = stats_parser.PlayerDataParser(self.fake_data)
#    self.assertTrue(data_parser._ParsePlayerStats(fake_stats))
#
#    # Lets verify that the map got updated accurately. Players with no position
#    # should not be added.
#    self.assertEquals(0, len(data_parser.player_stats_map))
#
#    self.mox.VerifyAll()
#
#  def testParsePlayerStatsFailEmptyPlayerData(self):
#    fake_stats = ''
#
#    self.mox.ReplayAll()
#    data_parser = stats_parser.PlayerDataParser(self.fake_data)
#    self.assertFalse(data_parser._ParsePlayerStats(fake_stats))
#    self.assertEquals(0, len(data_parser.player_stats_map))
#    self.mox.VerifyAll()
#
#  def testParsePlayerStatsFailInvalidPlayerId(self):
#    fake_stats = (
#        '["this-will-fail", "mouse", 1.2,[[[\'size\', [123]],[\'model\',[4]],3,'
#        '\'mouse\'')
#
#    self.mox.ReplayAll()
#    data_parser = stats_parser.PlayerDataParser(self.fake_data)
#    self.assertFalse(data_parser._ParsePlayerStats(fake_stats))
#    self.assertEquals(0, len(data_parser.player_stats_map))
#    self.mox.VerifyAll()
#
#  def testParsePlayerStatsFailInvalidPlayerName(self):
#    fake_stats = (
#        '[1234, 1234, 1.2,[[[\'size\', [123]],[\'model\',[4]],3,'
#        '\'mouse\'')
#
#    self.mox.ReplayAll()
#    data_parser = stats_parser.PlayerDataParser(self.fake_data)
#    self.assertFalse(data_parser._ParsePlayerStats(fake_stats))
#    self.assertEquals(0, len(data_parser.player_stats_map))
#    self.mox.VerifyAll()
#
#  def testParsePlayerStatsFailDuplicatePlayerId(self):
#    fake_stats = (
#        '[1234, "mouse", 1.2,[[[\'size\', [123]],[\'model\',[4]],3,'
#        '\'mouse\'')
#
#    self.mox.ReplayAll()
#    data_parser = stats_parser.PlayerDataParser(self.fake_data)
#
#    # Create a fake entry.
#    data_parser.player_stats_map[1234] = {'name': 'fake-mouse'}
#
#    self.assertFalse(data_parser._ParsePlayerStats(fake_stats))
#    self.assertEquals(1, len(data_parser.player_stats_map))
#    self.assertEquals('fake-mouse',
#                      data_parser.player_stats_map[1234]['name'])
#    self.mox.VerifyAll()
#
#  def testParsePlayerStatsFailDuplicateStat(self):
#    fake_stats = (
#        '[1234, "mouse", 1.2,[[[\'size\', [123]],[\'size\',[4]],3,'
#        '\'mouse\'')
#
#    self.mox.ReplayAll()
#    data_parser = stats_parser.PlayerDataParser(self.fake_data)
#    self.assertFalse(data_parser._ParsePlayerStats(fake_stats))
#    self.assertEquals(0, len(data_parser.player_stats_map))
#    self.mox.VerifyAll()
#
#
if __name__ == '__main__':
  unittest.main()
