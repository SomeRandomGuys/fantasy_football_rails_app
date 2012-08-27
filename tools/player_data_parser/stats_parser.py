"""A parser for player data.
"""

__author__ = 'akshaylal@gmail.com'

import logging
import re

PLAYER_ID_REGEX = re.compile('.*\[+(?P<id>(\d|\.)+).*')
PLAYER_NAME_REGEX = re.compile('.*(\'|\")(?P<name>(\S| )+)(\'|\").*')
PLAYER_STAT_REGEX = re.compile('.*\[+(\'|\")(?P<stat>\S+)(\'|\").*')
PLAYER_VALUE_REGEX = re.compile(
    r'.*\[+(\'|\")?(?P<value>(\d|\.|\w)+)(\'|\")?\]+.*')
SPLIT_ON_STRING = 'var initialData = '


class PlayerDataParserException(Exception):
  pass


class PlayerDataParser(object):
  """Parse an html page for player statistics."""

  def __init__(self, data):
    self.data = data
    self.player_stats_map = {}

  def ParsePlayerData(self):
    """Parse the player data from html page & update self.player_stats_map.

    Returns:
      True on success, else False.
    """
    player_data = self.data.split(SPLIT_ON_STRING)[-1]
    player_data = player_data.split(';')[0]
    player_data.strip()
    # Note: We need to replace all ]]],[ with a new line because the first
    # section which contains statistics about the team also contains information
    # about the first player (usually the goal keeper). This makes things tricky
    # to parse. So to avoid character counting, replace the ending of that
    # with a newline so that a generic parser can be applied to each line.
    player_data = re.sub('\]\]\]\,\[', '\n', player_data)

    for counter, line in enumerate(player_data.split('\n')):
      """
      This breaks the output into multiple lines.
      Line 0: summary about home game
      Line 1: summary aobut the team.
      Line 2-19: summary about home players (starting 11 + subs).
      Line 20-32: generic meta data.
      Line 33: summary about away team.
      Line 34-51: summary about away players (staring 11 + subs).
      Line 52-66: more meta data.
      """
      # Parse player data.
      if counter in xrange(2, 20) or counter in xrange(34, 52):
        # If there is a leading ',' lets remove it. It just complicates things.
        if line[0] == ',':
          line = line[1:]

        if not self._ParsePlayerStats(line):
          return False

    return True

  def _ParsePlayerStats(self, player_data):
    """Parse player data into a self.player_stats.

    The player data received is of the form:
    [unique_id, 'name', <na>, [[['key',[value]],...,['key',[value]]]],<na>,\
    'gen_position',<na>,<na>,<na>,'specific_position',<na>,<na>,<na>]

    Args:
      player_data: unparsed player data.

    Returns:
      True on success, else False.
    """
    player_id = ''
    per_player_stats_map = {}
    stat = ''
    value = ''

    for counter, line in enumerate(player_data.split(',')):
      # We want the unique id & name of the player.
      if counter == 0:
        m = PLAYER_ID_REGEX.match(line)
        if not m:
          logging.error('Failed to get player id from: %s', line)
          return False

        player_id = int(m.group('id'))
        if not player_id or player_id in self.player_stats_map:
          logging.error('Player id: %d is invalid/duplicate.', player_id)
          return False

        continue

      if counter == 1:
        m = PLAYER_NAME_REGEX.match(line)
        if not m:
          logging.error('Failed to get player name from: %s', line)
          return False

        per_player_stats_map['name'] = m.group('name')
        continue

      if not stat:
        m = PLAYER_STAT_REGEX.match(line)
        if m:
          stat = m.group('stat')
          # Sanity test this stat.
          if not stat or stat in per_player_stats_map:
            logging.error('Stat key: %s is invalid/duplicate.', stat)
            return False

          continue

      m = PLAYER_VALUE_REGEX.match(line)
      if m:
        value = m.group('value')
        # Now we know the value always succeedes the stat so we now have a stat
        # and a value pair. Lets write it into the dictionary.

       # Everything checked out fine. Lets add this data to the dictionary.
        per_player_stats_map[stat] = value

        stat = ''
        value = ''

    if not per_player_stats_map:
      logging.error('Didn\'t find any player stats for: %s', player_data)
      return False

    # TODO(akshaylal): Figure out a better solution for substitues that
    # don't get any pitch time.
    # Many times the position is not present along with quite a few key data
    # fields. This is usually the case when the player is a sub & did not
    # get any playing time. For now lets ignore these players. Theres really
    # no point in storing these stats since no points will be awarded for
    # these players anyway.
    if ('position' not in per_player_stats_map or
        per_player_stats_map['position'].lower() == 'sub'):
      return True

    # All checks passed, lets add this players data.
    self.player_stats_map[player_id] = per_player_stats_map
    return True
