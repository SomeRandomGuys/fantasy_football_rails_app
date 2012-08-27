"""Parse content from http://www.whoscored.com
"""

__author__ = 'akshaylal@gmail.com'

import argparse
import logging

import http_operations
import stats_parser


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

  return parser


def main():
  parser = SetupCommandLineFlags()
  args = parser.parse_args()

  SetupLogger(args.verbosity)

  player_stats = GetPlayerData(args.uri_list)
  if not player_stats:
    return False

  for key, value in player_stats.iteritems():
    logging.info('id: %d, name: %s, position: %s', key, value['name'],
                 value['position'])

  return True


if __name__ == '__main__':
  main()
