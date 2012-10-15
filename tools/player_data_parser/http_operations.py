"""HTTP Operations helper class.
"""

__author__ = 'akshaylal@gmail.com'

import httplib
import logging

# In seconds.
HTTP_TIMEOUT = 60
WHO_SCORED_URL = 'www.whoscored.com'


class HTTPOperationsException(Exception):
  pass


class HTTPOperations(object):
  """Handles all the HTTP operations."""

  def __init__(self, uri):
    self.uri = uri
    self.connection = ''
    if not self._CreateConnection():
      raise HTTPOperationsException(
          'Failed to create an HTTP connection to %s' % WHO_SCORED_URL)

  def _CreateConnection(self):
    """Creates an HTTPConnection object.

    Also sets self.connection.

    Returns:
      True on success else False.
    """
    try:
      self.connection = httplib.HTTPConnection(WHO_SCORED_URL)
    except httplib.InvalidURL, e:
      logging.error('Connection to %s failed. Error: %s', WHO_SCORED_URL, e)
      return False

    return True

  def Cleanup(self):
    """
    """
    self.connection.close()

  def GetPageContent(self):
    """
    """
    page_path = self.uri.split(WHO_SCORED_URL)[-1]
    data = ''

    try:
      self.connection.request('GET', page_path)
      res = self.connection.getresponse()
      if res.status != 200:
        raise HTTPOperationsException(
            'Failed to get data from: %s. Status: %s, Reason: %s' %
            (page_path, res.status, res.reason))
      data = res.read()

    except HTTPOperationsException, e:
      logging.error('Failed to get data from %s. Error: %s', page_path, e)
      return None

    return data
