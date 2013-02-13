"""A set of HTTP operations helper classes."""

__author__ = 'akshaylal@gmail.com'

import httplib
import logging

import common


class HTTPOperationsException(Exception):
  pass


class HTTPDataScraper(object):
  """Handles scraping of raw html data."""

  def __init__(self, uri):
    self.uri = uri
    self.connection = ''
    if not self._CreateConnection():
      raise HTTPOperationsException(
          'Failed to create an HTTP connection to %s' % common.WHO_SCORED_URL)

  def _CreateConnection(self):
    """Creates an HTTPConnection object.

    Also sets self.connection.

    Returns:
      True on success else False.
    """
    try:
      self.connection = httplib.HTTPConnection(common.WHO_SCORED_URL)
    except httplib.InvalidURL, e:
      logging.error('Connection to %s failed. Error: %s',
                    common.WHO_SCORED_URL, e)
      return False

    return True

  def Cleanup(self):
    """
    """
    self.connection.close()

  def GetPageContent(self):
    """
    """
    page_path = self.uri.split(common.WHO_SCORED_URL)[-1]
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
