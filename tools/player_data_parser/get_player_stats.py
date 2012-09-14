"""Parse content from http://www.whoscored.com
"""

__author__ = 'akshaylal@gmail.com'

import argparse
import logging

import http_operations
import stats_parser


DEFENCE_POSITIONS = ('DLR', 'DL', 'DC', 'DR', 'DCR')
FORWARD_POSITIONS = ('FW')
GOALKEEPER_POSITIONS = ('GK')
MIDFIELD_POSITIONS = ('M', 'MCL', 'DMC', 'ML', 'MC', 'MR', 'AML', 'AMC', 'AMR', 'AMCLR')


def GetPlayerData(uri_list):
  """The orchestrator."""
  player_stats = {}

  for uri in uri_list:
    http_obj = http_operations.HTTPOperations(uri)
    html_data = http_obj.GetPageContent()
    if not html_data:
      return False
    http_obj.Cleanup()

    stats_parser_obj = stats_parser.PlayerDataParser(html_data)
    if not stats_parser_obj.ParsePlayerData():
      return False

    # Update the values for the player stats, but first ensure that we don't
    # have duplicate keys (player ids).
    for key, value in stats_parser_obj.player_stats_map.iteritems():
      if key in player_stats:
        logging.error('Duplicate key: %s found in player_stats map: %s',
                      key, player_stats)
        return False

      player_stats[key] = value

  return player_stats


def GetStatsPerPosition(player_stats):
  """Iterate over the player_stats map & list the stats per position.

  Args:
    player_stats: A dictionary containing all the stats per player.

  Returns:
    True on success else False.
  """
  defence_stats = ()
  forward_stats = ()
  goalkeeping_stats = ()
  midfield_stats = ()

  for key, value in player_stats.iteritems():
    position = value['position']

    # Get a set of all the stats per generic position.
    if position in DEFENCE_POSITIONS:
      defence_stats = _UpdateStats(defence_stats, set(value))
    elif position in FORWARD_POSITIONS:
      forward_stats = _UpdateStats(forward_stats, set(value))
    elif position in GOALKEEPER_POSITIONS:
      goalkeeping_stats = _UpdateStats(goalkeeping_stats, set(value))
    elif position in MIDFIELD_POSITIONS:
      midfield_stats = _UpdateStats(midfield_stats, set(value))
    else:
      logging.error('name:%s in position: %s not in list.', value['name'],
                    position)
      return False

  # Log all the stats.
  if (not defence_stats or not forward_stats or not goalkeeping_stats or
      not midfield_stats):
    logging.error('Not stats found for all positions. Defence: %s, Forward: %s,'
                  'Goalkeeping: %s, Midfield: %s', defence_stats, forward_stats,
                  goalkeeping_stats, midfield_stats)
    return False

  logging.info('Defence stats: %s, %d', defence_stats, len(defence_stats))
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
  for key, value in player_stats_map.iteritems():
    logging.info('team_id: %d, team_name: %s, id: %d, name: %s, position: %s, '
                 'mins_played: %s', value['team_id'], value['team_name'],
                 key, value['name'], value['position'], value['mins_played'])


def _UpdateStats(stats, player_stats_set):
  """
  """
  if not stats:
    stats = player_stats_set
  else:
    # Get the set intersection.
    if stats != set(player_stats_set):
      logging.error('Different stats found for the same general position: %s '
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

  player_stats = GetPlayerData(args.uri_list)
  if not player_stats:
    return False

  # Print out all the players & their positions.
  PrintParsedPlayers(player_stats)

  if args.statistics_keys:
    if not GetStatsPerPosition(player_stats):
      return False


if __name__ == '__main__':
  main()
