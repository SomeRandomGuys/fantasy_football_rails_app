"""Parse content from http://www.whoscored.com
"""

__author__ = 'akshaylal@gmail.com'

import argparse
import logging
import sys

import http_operations
import stats_parser


DEFENSE_POSITIONS = ('DLR', 'DL', 'DC', 'DR', 'DCR')
FORWARD_POSITIONS = ('FW')
GOALKEEPER_POSITIONS = ('GK')
MIDFIELD_POSITIONS = ('M', 'MCL', 'DMC', 'ML', 'MC', 'MR', 'AML', 'AMC', 'AMR',
                      'AMCLR')


def GetPlayerData(uri_list):
  """The orchestrator."""
  stats_parser_obj = stats_parser.PlayerDataParser()
  player_data = {}

  for uri in uri_list:
    http_obj = http_operations.HTTPOperations(uri)
    html_data = http_obj.GetPageContent()
    if not html_data:
      return False
    http_obj.Cleanup()

    stats_parser_obj.Reset()
    if not stats_parser_obj.ParsePlayerData(html_data):
      return False
    player_data.update(stats_parser_obj.player_stats_map)

  return player_data


def GetStatsPerPosition(player_stats):
  """Iterate over the player_stats map & list the stats per position.

  Args:
    player_stats: A dictionary containing all the stats per player.

  Returns:
    True on success else False.
  """
  defense_stats = ()
  forward_stats = ()
  goalkeeping_stats = ()
  midfield_stats = ()

  for key, value in player_stats.iteritems():
    # Lets ignore all stats for players who don't fall into our preset buckets.
    position = value['position']

    # Get a set of all the stats per generic position.
    if position in DEFENSE_POSITIONS:
      defense_stats = _UpdateStats(defense_stats, set(value))
    elif position in FORWARD_POSITIONS:
      forward_stats = _UpdateStats(forward_stats, set(value))
    elif position in GOALKEEPER_POSITIONS:
      goalkeeping_stats = _UpdateStats(goalkeeping_stats, set(value))
    elif position in MIDFIELD_POSITIONS:
      midfield_stats = _UpdateStats(midfield_stats, set(value))
    else:
      logging.debug('name:%s in position: %s not in list.',
                    value['player_name'], position)
      continue

  # Log all the stats.
  if (not defense_stats or not forward_stats or not goalkeeping_stats or
      not midfield_stats):
    logging.error('Not stats found for all positions.')
    return False

  logging.info('Defense stats: %s, %d', defense_stats, len(defense_stats))
  logging.info('Foward stats: %s, %d', forward_stats, len(forward_stats))
  logging.info('Goalkeeping stats: %s, %d', goalkeeping_stats,
               len(goalkeeping_stats))
  logging.info('Midfielding stats: %s, %d', midfield_stats,
               len(midfield_stats))

  return True


def PrintParsedPlayers(player_stats_map):
  """Iterates over the player_stats_map & prints the name & id of the player.

  Args:
    player_stats_map: A dictionary key'd by the id of the player containing all
    relevant stats as a second level dictionary.
  """
  for _, value in player_stats_map.iteritems():
    logging.info('team_id: %s, team_name: %s, player_id: %s, player_name: %s, '
                 'position: %s, mins_played: %s', value['team_id'],
                 value['team_name'], value['player_id'], value['player_name'],
                 value['position'], value['mins_played'])


def _UpdateStats(stats, player_stats_set):
  """
  """
  if not stats:
    stats = player_stats_set
  else:
    # Get the set intersection.
    if stats != set(player_stats_set):
      logging.debug('Different stats found for the same general position: %s '
                    'Unifying stats.', set.difference(stats, player_stats_set))
      stats = set.union(stats, (player_stats_set))

  return stats


def SetupLogger(verbosity):
  """Initialize the root logger."""
  if verbosity:
    logging.getLogger('').setLevel(logging.DEBUG)
  else:
    logging.getLogger('').setLevel(logging.INFO)

  # Set the format.
  logging.basicConfig(format=
      '%(asctime)s %(pathname)s:%(lineno)d %(levelname)s %(message)s')


def SetupCommandLineFlags():
  """Initialize all command line flags.

  Returns:
    A argparse.ArgumentParser object.
  """
  parser = argparse.ArgumentParser(
      description='Parses html content from a specifed uri & returns the player'
                  ' statistics')
  parser.add_argument('-u', '--uri', dest='uri_list', required=True,
                      type=str, action='append', help='The list of URI path.')
  parser.add_argument('-v', '--verbose', dest='verbosity', action='store_true',
                      default=False, help='Logging verbosity.')
  parser.add_argument('--statistics_keys', dest='statistics_keys',
                      action='store_true', default=False,
                      help=('Get the union of all statistics for player that '
                            'played the game per position. We do not consider '
                            'any stats from substitues that did not get any '
                            'game time.'))

  return parser


def main():
  parser = SetupCommandLineFlags()
  args = parser.parse_args()

  SetupLogger(args.verbosity)

  player_stats_map = GetPlayerData(args.uri_list)
  if not player_stats_map:
    return False

  # Print out all the players & their positions.
  PrintParsedPlayers(player_stats_map)

  if args.statistics_keys:
    if not GetStatsPerPosition(player_stats_map):
      return False

  return True


if __name__ == '__main__':
  sys.exit(not main())
