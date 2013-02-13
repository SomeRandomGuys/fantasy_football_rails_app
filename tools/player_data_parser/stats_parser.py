"""A parser for player data."""

__author__ = 'akshaylal@gmail.com'

import datetime
import json
import logging
import re

import common
import rest_operations

SPLIT_ON_STRING = 'var initialData = '
LENGTH_PLAYER_STATS_LIST = 13

class InvalidPlayerStatsException(Exception):
  pass


class StatsParser(object):
  """Parse an html page for player statistics."""

  def __init__(self, rest_ops_obj):
    assert rest_ops_obj
    self.player_stats_map = {}
    self.json_list = None
    self.rest_ops_obj = rest_ops_obj
    self.home_team = ""
    self.away_team = ""
    self.Reset()

  def Reset(self):
    """Resets all data in the player_stats_map & json_list."""
    self.player_stats_map = {}
    self.json_list = None

  def StorePlayerDataToBackend(self, html_data):
    """Stores the player_stats_map to the backend.

    Args:
      html_data: the raw html_data.

    Returns:
      True on success, else False.
    """
    assert self.rest_ops_obj
    assert html_data

    # Step 1: Parse the html data, generate a match id & update
    # self.player_stats_map
    self.ParsePlayerData(html_data)

    # Step 2: Update the backend with the player stats.
    self.rest_ops_obj.StorePlayerStats(self.match_id,
                                       self.player_stats_map)

    logging.info('Player stats for match_id: %d, stored successfully to '
                 'backend.', self.match_id)

  def ParsePlayerData(self, html_data):
    """Parse the player data from html page & update self.player_stats_map.

    Args:
      html_data: the raw html_data.

    Returns:
      True on success, else False.
    """
    if not self._CreateJsonInstance(html_data):
      return False
    logging.debug('JSON data deserialized.')

    # At this point the parsed json_list has 2 elements.
    # 0: a list of lists contains all the stats we need/want.
    # 1: the integer 0 (not sure why).
    #
    # Within the first element heres how the stats are laied out:
    # 0: a list containing the summary about the game.
    # 1: a list of lists containing all the stats about the game.
    #
    # From the first list we would like to gather the following stats:
    # a. home team name.
    # b. away team name.
    # c. home score.
    # d. away score.
    # e. date the game was played (UTC date).
    (self.home_team, self.away_team, home_score, away_score,
     match_date) = self._ParseMatchMetaData(self.json_list[0][0])

    # Before parsing any data lets first get a new match_id.
    self.match_id = self.rest_ops_obj.GetMatchId(
        self.home_team, home_score, self.away_team, away_score,
        datetime.datetime.strftime(match_date, '%Y/%m/%d %H:%M:%S'))
    logging.info('New match id: %s', self.match_id)

    self.player_stats_map['away_team'] = {'team_name': self.away_team,
                                          'players': []}
    self.player_stats_map['home_team'] = {'team_name': self.home_team,
                                          'players': []}

    # All the player stats we really need are part of the second element. This
    # contains:
    # 0: a list of lists containing stats for the home team/players.
    # 1: a list of lists containing stats for the away team/players.
    for stats in self.json_list[0][1]:
      (who_scored_team_name,
       player_stats_list) = self._ParseStats(stats)

      # Put the player stats into the correct location (team) in
      if who_scored_team_name == self.home_team:
        self.player_stats_map['home_team'].update(
            {'players': player_stats_list})
      elif who_scored_team_name == self.away_team:
        self.player_stats_map['away_team'].update(
            {'players': player_stats_list})
      else:
        # We should never reach here.
        assert False

    return True

  def _ParseMatchMetaData(self, match_stats):
    """Parse the match_stats and return some general meta-data about the game.

    The list contains the following entries:
      0. WhoScored home team id.
      1. WhoScored away team id.
      2. Home team name,
      3. Away team name,
      4. Date & time match started (mm/dd/yyyy hh:mm:ss)
      5. Date match started (mm/dd/yyyy 00:00:00)
      6 - 10. Usless stats as far as I can tell.
      11. Final score as a string 'Home : Away'

    Args:
      match_stats: a list containing all the match stats.

    Returns:
      home_team: the name of the home team.
      away_team: the name of the away team.
      home_score: the number of goals scored by the home team.
      away_score: the number of goals scored by the away team.
      match_date: the date (utc) when the match was played.
    """
    assert len(match_stats) == 12
    home_score, away_score = common.UnicodeToString(
        match_stats[11]).split(' : ')

    return (common.UnicodeToString(match_stats[2]),
            common.UnicodeToString(match_stats[3]), home_score, away_score,
            datetime.datetime.strptime(match_stats[4], '%m/%d/%Y %H:%M:%S'))

  def _NormalizeHTMLData(self, html_data):
    """Parses & cleans up the html data so that it can be desearlized.

    Args:
      html_data: the raw html data.

    Returns:
      a normalized string that should be able to be deserialized into a python
      object.
    """
    player_data = html_data.split(SPLIT_ON_STRING)[-1]
    player_data = player_data.split(';')[0]
    player_data.strip()

    # Cleanup the data so that we can import the json output.
    # Replace the single quotes with double quotes.
    player_data = player_data.replace("'", '"')
    # Replace ",,," with ","None".".
    player_data = player_data.replace(',,,', ',"None",')
    # Replace all \r\n with ''.
    player_data = player_data.replace('\r\n', '')

    return player_data

  def _CreateJsonInstance(self, html_data):
    """Deserialize the html containing the required JSON into a python obj.

    Once the html is deserialized, self.json_list is set.

    Args:
      html_data: the raw html data.

    Returns:
      True on success, else False.
    """
    try:
      player_data = self._NormalizeHTMLData(html_data)
      self.json_list = json.loads(player_data)
      if not self.json_list and len(self.json_list) == 2:
        raise ValueError('Parsed JSON object is invalid.')
    except ValueError, e:
      logging.error('Failed to create a json list. Error: %s', e)
      return False

    return True

  def _ParseStats(self, stats):
    """Parse the team & player stats.

     This list should contain the following elements:
     0: team id.
     1: team name.
     2: overall team rating.
     3: a list of lists consisting of stats about the team.
     4: a list of lists consisting of stats for all the players.
     5: a list of lists consisting of metastats about the team (useless).

    Args:
      stats: the deserialized json list containing stats for all players on a
      team.

    Returns:
      team_name: the whoscored team_name.
      player_stats_list: a list of player stats dicts.

    Raises:
      InvalidPlayerStatsException: if the length of the json list per player
      is not equal to LENGTH_PLAYER_STATS_LIST.
    """
    team_name = stats[1]
    player_stats_list = []

    for player_stats in stats[4]:
      # All stats should have LENGTH_PLAYER_STATS_LIST entries.
      if len(player_stats) != LENGTH_PLAYER_STATS_LIST:
        raise InvalidPlayerStatsException(
            "Length of player stats: %d, expected: %d. List contents: %s" %
            (len(player_stats), LENGTH_PLAYER_STATS_LIST, player_stats))

      player_stats_list.append(
          self._ParsePlayerStats(player_stats, team_name))

    logging.debug('Number of player stats parsed: %d',
                  len(player_stats_list))
    return team_name, player_stats_list

  def _ParsePlayerStats(self, player_stats, team_name):
    """Returns a dictionary of all the stats for a given player.

    Each player stats list should have only 13 elements.
    0: player id.
    1. player name.
    2. overall rating.
    3. a list of lists consiting of all the stats for the player.
    4. shirt number.
    5. starting position (can be Sub)
    6. (not sure really but not useful).
    7. 0/1/2.
        0: played all 90 mins or played nothing at all.
        1: got subbed out.
        2: got subbed in.
    8. 0/<integer>.
        0: never got subbed {in, out} or never played.
        <integer>: time when subbed {in, out}
    9. positions usually played (can be a whole slew of positions).
    10. age
    11. height in cms.
    12. (not sure really but not useful).

    The list (of  lists) of player stats is, for some reason, of the form:
      [[
        [key,[val]],
        [key,[val]]
        ...
      ]]

    Args:
      team_name: the name of the team.
      player_stats: a list of lists consisting of stats for a single player.

    Returns:
      a dict of the form:
        {
         first_name: <first_name>,
         last_name: <last_name>,
         stats: {'stat':'value', 'stat':'value'...}
        }
    """
    # Create a dict out of the player_stats list so that we can access it
    # faster. Each element in the list containts 2 futher elements:
    # 0. the key
    # 1. a list containing a single element, the value.
    whoscored_stats = dict(
        (common.UnicodeToString(key), common.UnicodeToString(val[0]))
        for key, val in player_stats[3][0])

    # Initialize all the required keys in the parsed_stats.
    parsed_stats = self._InitializePerPlayerStatsMap()

   # Iterate over all the stats in the parsed_stats & set the values based on
    # common.PLAYER_STATS_MAPPING.
    for stat in parsed_stats:
      stats_set = common.PLAYER_STATS_MAPPING.get(stat, None)
      assert stats_set

      # Iterate over all the elements in the stats_set and update the
      # parsed_stats with the required (summation) of all the stats.
      for ele in stats_set:
        if ele in whoscored_stats:
          parsed_stats[stat] += int(whoscored_stats[ele])

    # TODO(alal): fix these gotchas.
    # direct red = red_card & no second_yellow
    # shots_on_target = the actual goal + ontarget_scoring_att

    # Player name.
    player_name = player_stats[1].split(' ')
    first_name = common.UnicodeToString(player_name[0])
    last_name = ''
    if len(player_name) > 1:
      last_name = common.UnicodeToString(' '.join(player_name[1:]))

    # Update the parsed_stats with the Whoscored rating.
    # parsed_stats['who_scored_rating'] = float(whoscored_stats['rating'])

    return {'first_name': first_name, 'last_name': last_name,
            'stats': parsed_stats}

  def _InitializePerPlayerStatsMap(self):
    """Initializes a map with the required player stats with defauls as 0.

    Returns:
      player_stats: an initialized dictionary instance.
    """
    return dict((ele, 0) for ele in common.PLAYER_STATS_MAPPING)
