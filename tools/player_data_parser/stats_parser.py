"""A parser for player data.
"""

__author__ = 'akshaylal@gmail.com'

import json
import logging
import re
import unicodedata

SPLIT_ON_STRING = 'var initialData = '


class PlayerDataParser(object):
  """Parse an html page for player statistics."""

  def __init__(self):
    self.player_stats_map = {}
    self.json_list = None

  def Reset(self):
    """Resets all data in the player_stats_map & json_list."""
    self.player_stats_map = {}
    self.json_list = None

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
    # 1: the integer 0 (not sure why.).
    #
    # Within the first element heres how the stats are laied out:
    # 0: a list containing the summary about the game.
    # 1: a list of lists containing all the stats about the game.
    #
    # We ideally care more about the second element at this point since all the
    # stats we really need are in there.
    # 0: a list of lists containing stats for the home team/players.
    # 1: a list of lists containing stats for the away team/players.
    for stats in self.json_list[0][1]:
      if not self._ParseStats(stats):
        return False

    return True

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
      True on success, else False.
    """
    team_id = stats[0]
    team_name = stats[1]

    for player_stats in stats[4]:
      # All stats should have 13 entries. No more, no less.
      if len(player_stats) != 13:
        logging.error('Invalid player stats list. Should have 13 entries, '
                      'acutally seen: %d. Stats: %s', len(player_stats),
                      player_stats)
        return False

      self.player_stats_map.update(
          self._ParsePlayerStats(player_stats, team_id, team_name))

    logging.debug('Number of player stats parsed: %d',
                  len(self.player_stats_map))
    return True

  def _ToAscii(self, value):
    """Coverts a unicode value into a string.

    Args:
      value: the unicode string.

    Returns:
      an ascii string.
    """
    if isinstance(value, unicode):
      return unicodedata.normalize('NFKD', value).encode('ascii','ignore')
    else:
      return str(value)


  def _ParsePlayerStats(self, player_stats, team_id, team_name):
    """Creates a dictionary of all the stats for a given player.

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
      team_id: the id for the team.
      team_name: the name of the team.
      player_stats: a list of lists consisting of stats for a single player.

    Returns:
      a dict of the form:
        { player_id: { 'stat':'value', 'stat':'value'...}}
    """
    # Ensure that we haven't already parsed this player id.
    assert player_stats[0] not in self.player_stats_map

    # For players who didn't get to play at all, there won't be any key called
    # 'mins_played'. Lets set this to some default value along with some other
    # defaults.
    player_dict = {
        'team_id': int(team_id),
        'team_name': team_name,
        'player_id': int(player_stats[0]),
        'player_name': self._ToAscii(player_stats[1]),
        'shirt_number': int(player_stats[4]),
        'starting_position': player_stats[5],
        'mins_played': int(0),
        'position': player_stats[9],
    }

    # Convert all the lists of lists into key/vals that can be entered into the
    # player_dict.
    # Note: a presumption is being made that all the values, which
    # are represented as lists themselves have only a sinlge element.
    player_dict.update(
        dict((self._ToAscii(key), self._ToAscii(value[0]))
            for key, value in player_stats[3][0]))

    # If the players position is set to 'sub' lets revert it back to all the
    # possible positions he can play.
    if player_dict['position'].lower() == 'sub':
      player_dict['position'] = player_stats[9]

    return {player_stats[0]: player_dict}
