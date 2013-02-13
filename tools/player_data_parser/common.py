"""Defines a single location for all the constants."""

__author__ = 'akshaylal@gmail.com'

import unicodedata

DB_API_URIS = {'GetMatchID': '/api/new_match.json',
               'StorePlayerStats': '/api/match_player_stats.json'}
HTTP_TIMEOUT = 60  # In seconds.
WHO_SCORED_URL = 'www.whoscored.com'
# A mapping of the backend keys to a tuple of all the required whoscored keys.
PLAYER_STATS_MAPPING = {
    'mins_played': ('mins_played',),
    'goals_scored': ('goal_normal', 'att_pen_goal'),
    'goals_allowed': ('goals_conceded_gk',),
    'goal_assists': ('goal_assist',),
    'own_goals': ('own_goals',),
    'red_card_count': ('red_card',),
    'yellow_card_count': ('yellow_card', 'second_yellow'),
    'tackles_fail': ('tackle_lost',),
    'tackles_successful': ('won_tackle',),
    'passes_fail': ('pass_inaccurate',),
    'passes_successful': ('accurate_pass',),
    'shots_on_target': ('ontarget_scoring_att', 'goal_normal'),
    'shots_off_target': ('shot_off_target',),
    'shots_saved': ('saves',),
    'penalty_scored': ('penalty_shootout_scored', 'att_pen_goal'),
    'penalty_missed': ('penalty_missed',),
    'penalty_saved': ('penalty_shootout_saved',),
    'dribbles_lost': ('dribble_lost'),
    'man_of_the_match' : ('man_of_the_match',),
}


def UnicodeToString(value):
  """Coverts a unicode value into a string.

  Args:
    value: the unicode string.

  Returns:
    a string.
  """
  if isinstance(value, unicode):
    return str(unicodedata.normalize('NFKD', value).encode('ascii','ignore'))
  else:
    return str(value)
