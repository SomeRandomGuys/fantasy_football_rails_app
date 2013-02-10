#!/usr/bin/python2.7
"""Parse content from http://www.whoscored.com"""

__author__ = 'akshaylal@gmail.com'

import argparse
import logging
import sys

import http_operations
import rest_operations
import stats_parser


def StorePlayerDataInDB(server_uri, api_key, uri_list):
  """The orchestrator."""
  rest_ops_obj = rest_operations.RestOperations(server_uri, api_key)
  stats_parser_obj = stats_parser.StatsParser(rest_ops_obj)

  for uri in uri_list:
    http_obj = http_operations.HTTPDataScraper(uri)
    html_data = http_obj.GetPageContent()
    if not html_data:
      return False
    http_obj.Cleanup()

    stats_parser_obj.Reset()
    stats_parser_obj.StorePlayerDataToBackend(html_data)


def SetupLogger(verbosity):
  """Initialize the root logger."""
  if verbosity:
    logging.getLogger('').setLevel(logging.DEBUG)
  else:
    logging.getLogger('').setLevel(logging.INFO)

  # Set the format.
  logging.basicConfig(format=
      '%(asctime)s %(filename)s:%(lineno)d %(levelname)s %(message)s')


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
  parser.add_argument('--api_key', dest='api_key', required=True,
                      type=str, action='store', help='The users api key.')
  parser.add_argument('--server_uri', dest='server_uri', required=True,
                      type=str, action='store', help='The URI to the server.')
  parser.add_argument('-v', '--verbose', dest='verbosity', action='store_true',
                      default=False, help='Logging verbosity.')
  return parser


def main():
  parser = SetupCommandLineFlags()
  args = parser.parse_args()

  SetupLogger(args.verbosity)

  StorePlayerDataInDB(args.server_uri, args.api_key,
                      args.uri_list)
  return 0


if __name__ == '__main__':
  sys.exit(main())
