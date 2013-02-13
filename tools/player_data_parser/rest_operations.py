"""REST Operations helper class."""

__author__ = 'akshaylal@gmail.com'

import logging
import json
import urllib2

import common

class RestOperationsException(Exception):
  pass


class RestOperations(object):
  """Handles all POST & GET rest calls."""

  def __init__(self, server_uri, api_key=None, header=None,
               timeout=common.HTTP_TIMEOUT):
    self._server_uri = server_uri
    self._api_key = api_key

    if not header:
      self._header = {'Content-Type': 'application/json'}
    else:
      self._header = header
    self._timeout = timeout

  def GetMatchId(self, home_team, home_score, away_team, away_score,
                 match_date):
    """Returns a new match id.

    Args:
      home_team: the name of the home team.
      home_score: the goals scored by the home team.
      away_team: the name of the away team.
      away_score: the goals scored by the away team.
      match_date: the date the game was played. format: UTC YYYY-MM-DD 00:00:00

    Returns:
      match_id: the match id.

    Raises:
      RestOperationsException: if an error message exists in the returned
      JSON object.
    """
    request_dict = {'home_team': home_team,
                    'home_score': home_score,
                    'away_team': away_team,
                    'away_score': away_score,
                    'match_date': match_date}
    new_request_dict = {}
    new_request_dict['new_match'] = request_dict
    response = self._Post(common.DB_API_URIS['GetMatchID'], new_request_dict)

    # Lets ensure that the response has valid fields.
    if response['error']:
      raise RestOperationsException(
          'Failed to get a new MatchID. Error text: %s' % (response['error']))

    # Parse the JSON output and return the match id.
    return int(common.UnicodeToString(response['return']['id']))

  def StorePlayerStats(self, match_id, player_stats):
    """Stores all the player stats to the backend.

    Args:
      match_id: the match id.
      player_stats: a dict containing all the player stats by team.

    Returns:
      True on success else False.

    Raises:
      RestOperationsException: if an error message exists in the returned
      JSON object.
    """
    request_dict = player_stats
    request_dict['match_id'] = match_id

    new_request_dict = {}
    new_request_dict['match_player_stats'] = request_dict
    response = self._Post(common.DB_API_URIS['StorePlayerStats'],
                          new_request_dict)

    # Lets ensure that the response has valid fields.
    if response['error']:
      raise RestOperationsException(
          'Failed to store player stats. Error text: %s' % (response['error']))

    # Parse the JSON output and return the match id.
    return True

  def _Post(self, uri, request_dict):
    """Converts the request_dict into a json object and sends the POST req.

    Args:
      uri: where to send the POST request.
      request_dict: a dictionary containing the request to send.

    Returns:
      response_dict: a dictionary containing the response.

    Raises:
      RestOperationsException: if any method parameters are invalid or if the
      POST request fails.
    """
    # Ensure that the request_dict can be converted to a json object encoded
    # using UTF-8.
    if not request_dict:
      raise RestOperationsInvalidArgsException('Request dictionary is empty')

    if not uri:
      raise RestOperationsInvalidArgsException('URI is empty')

    request_json = json.dumps(request_dict).encode('utf-8')
    logging.debug('Request json: %s', request_json)

    try:
      post_uri = '%s/%s' % (self._server_uri.rstrip('/'), uri.lstrip('/'))
      secure_post_uri = self._AddApiKey(post_uri)
      logging.debug('Sending POST request to: %s', secure_post_uri)
      res = urllib2.urlopen(
          urllib2.Request(secure_post_uri, request_json, self._header),
          timeout=self._timeout)
    except (urllib2.URLError, urllib2.HTTPError) as error:
      logging.error('Failed to send POST request to %s.', secure_post_uri)
      raise

    if res.getcode() != 200:
      # Things should be okay.
      raise RestOperationsException(
          'POST operation failed. Return code: %s, Error text: %s' %
          (res.getcode(), res.msg))

    # Everything worked out fine. Lets return the json object.
    return json.loads(res.read())

  def _AddApiKey(self, post_uri):
    """Adds the api key to the uri."""
    return '{0}?api_key={1}'.format(post_uri, self._api_key)
