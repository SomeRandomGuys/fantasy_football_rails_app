"""A parser for player data.
"""

__author__ = 'akshaylal@gmail.com'

import logging
import re

import constants


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
    player_data = self.data.split(constants.SPLIT_ON_STRING)[-1]
    player_data = player_data.split(';')[0]
    player_data.strip()
    # Note: We need to replace all ]]],[ with a new line because the first
    # section which contains statistics about the team also contains information
    # about the first player (usually the goal keeper). This makes things tricky
    # to parse. So to avoid character counting, replace the ending of that
    # with a newline so that a generic parser can be applied to each line.
    player_data = re.sub('\]\]\]\,\[', '\n', player_data)

    team_name = ''
    team_id = ''
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
      # Get the the team id & name.
      if counter == 1 or counter == 33:
        try:
          team_id, team_name = self._ParseTeamStats(line)
          logging.debug('Team id: %d, Team name: %s', team_id, team_name)
        except ValueError, e:
          logging.error('Failed to grab team_name or team_id. Error: %s', e)
          return False

        continue

      # Parse player data.
      if counter in xrange(2, 20) or counter in xrange(34, 52):
        # If there is a leading ',' lets remove it. It just complicates things.
        if line[0] == ',':
          line = line[1:]

        if not self._ParsePlayerStats(line, team_id, team_name):
          return False

    return True

  def _ParseTeamStats(self, data):
    """Parse the team name and id.

    Parse a line that has content in the form:
     , [[23,'Newcastle United',6.76, ....

    Args:
      data: a line from the html.

    Returns:
      team name: the name of the team.
      team id: the id associated with this team.
    """
    team_name = ''
    team_id = ''
    m = re.match(constants.TEAM_NAME_ID_REGEX, data)
    if m:
      team_name = m.group('name')
      team_id = int(m.group('id'))

      if team_name and team_id:
        return team_id, team_name

    raise ValueError('Team name: %s or team id: %s not found.' %
                     (team_name, team_id))

  def _ParsePlayerStats(self, player_data, team_id, team_name):
    """Parse player data into a self.player_stats.

    The player data received is of the form:
    [unique_id, 'name', <na>, [[['key',[value]],...,['key',[value]]]],\
    <na>, 'starting_pos',shirt_num,not_sub:0 sub:1/2,min_sub,\
    'specific_position',<na>,<na>,<na>]

    Args:
      player_data: unparsed player data.
      team id: the id associated with this team.
      team name: the name of the team.

    Returns:
      True on success, else False.
    """
    player_id = ''
    per_player_stats_map = {}
    stat = ''
    value = ''
    position = ''

    for counter, line in enumerate(player_data.split(',')):
      # We want the unique id & name of the player.
      if counter == 0:
        m = constants.PLAYER_ID_REGEX.match(line)
        if not m:
          logging.error('Failed to get player id from: %s', line)
          return False

        player_id = int(m.group('id'))
        if not player_id or player_id in self.player_stats_map:
          logging.error('Player id: %d is invalid/duplicate.', player_id)
          return False

        continue

      if counter == 1:
        m = constants.PLAYER_NAME_REGEX.match(line)
        if not m:
          logging.error('Failed to get player name from: %s', line)
          return False

        per_player_stats_map['name'] = m.group('name')
        continue

      if not stat:
        m = constants.PLAYER_STAT_REGEX.match(line)
        if m:
          stat = m.group('stat')
          # Sanity test this stat.
          if not stat or stat in per_player_stats_map:
            logging.error('Stat key: %s is invalid/duplicate.', stat)
            return False

          continue

      m = constants.PLAYER_VALUE_REGEX.match(line)
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

    # TODO(akshaylal): This is a really bad hack. We need to figure out a
    # smarter way to parse this data from the html.
    # All the stats parsed so far do not tell us whether this particular player
    # substituted & if so when. This data does exist in the "player_data" but
    # not as part of any key, val structure. It is part of the last few sections
    # of the "player_data", along with:
    # <na>,'gen_pos',shirt_num,not_sub:0 sub:1/2,min_sub,
    # Given that, lets parse the end of the "player_data" again.
    if not self._ParsePlayerMetaStats(player_data, per_player_stats_map):
      return False

    # Lets also update the dictionary with the players team name & id.
    per_player_stats_map['team_name'] = team_name
    per_player_stats_map['team_id'] = team_id

    # All checks passed, lets add this players data.
    self.player_stats_map[player_id] = per_player_stats_map
    return True

  def _ParsePlayerMetaStats(self, player_data, per_player_stats_map):
    """Parse the final section of the player data & update per_player_stats_map.

    Parse the following data from the end of the player data html.
      <na>,'starting_pos',shirt_num,not_sub:0 sub:1/2,min_sub,\
      'specific_position'

    Args:
      player_data: the html data for the player.
      per_player_stats_map: a dictionary containing all the parsed stats of the
      player.

    Returns:
      True on success, else False.
    """
    final_section = player_data.split(']]],')[-1].split(',')
    starting_pos, shirt_num, got_sub, time_sub, position = final_section[1:6]

    # If the position is already present in the dictionary, then this player
    # started the game & we don't need to change it. If however, the current
    # position value is 'sub' or is not present, lets set it now.
    if (not per_player_stats_map['position'] or
        per_player_stats_map['position'].lower() == 'sub'):
      per_player_stats_map['position'] = position.replace('(', '').replace(
          ')', '').strip("'").strip('"')

    per_player_stats_map['shirt_number'] = int(shirt_num)

    # Get rid of the quotes around the starting position.
    starting_pos = starting_pos.strip("'").strip('"')

    # Add the a stat about of mins_played.
    if starting_pos.lower() == 'sub' and int(time_sub) == 0:
      per_player_stats_map['mins_played'] = int(time_sub)

    elif int(got_sub) == constants.SUB_IN:
      per_player_stats_map['mins_played'] = (
          constants.MATCH_TIME_MINS - int(time_sub))

    elif int(got_sub) == constants.SUB_OUT:
      per_player_stats_map['mins_played'] = int(time_sub)

    else:
      per_player_stats_map['mins_played'] = constants.MATCH_TIME_MINS

    return True
