"""A list of global constants.
"""

__author__ = 'akshaylal@gmail.com'

import re

MATCH_TIME_MINS = 90

PLAYER_ID_REGEX = re.compile(r'.*\[+(?P<id>(\d|\.)+).*')
PLAYER_NAME_REGEX = re.compile(r'.*(\'|\")(?P<name>(\S| )+)(\'|\").*')
PLAYER_STAT_REGEX = re.compile(r'.*\[+(\'|\")(?P<stat>\S+)(\'|\").*')
PLAYER_VALUE_REGEX = re.compile(
    r'.*\[+(\'|\")?(?P<value>(\d|\.|\w)+)(\'|\")?\]+.*')
TEAM_NAME_ID_REGEX = re.compile(
    r'.*\[+(?P<id>\d+),(\'|\")(?P<name>(\w| )+)(\'|\"),.*')

SPLIT_ON_STRING = 'var initialData = '

SUB_IN = 2
SUB_OUT = 1
