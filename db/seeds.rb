TEAMS_FILE = "#{Rails.root}/db/teams.txt"
PLAYERS_FILE = "#{Rails.root}/db/players.txt"

# Leagues
League.delete_all
League.create({ :name => "English Premier League", :code => "EPL", :country => "England" })

# Field Positions
Position.delete_all
Position.create([{:position => "Midfielder", :field_position => "Midfield", :code => "MF"},
                             {:position => "Forward", :field_position => "Forward", :code => "FW"},
                             {:position => "Defender", :field_position => "Defence", :code => "DF"},
                             {:position => "Goalkeeper", :field_position => "Goalkeeper", :code => "GK"}]) 

# EPL Teams
Team.delete_all
open(TEAMS_FILE) do |teams|
  teams.read.each_line do |team|
    name = team.chomp
    league_id = League.where(:code => "EPL").first.id
    Team.create({ :name => name, :league_id => league_id })
  end
end

# EPL Players
Player.delete_all
open(PLAYERS_FILE) do |players|
  players.read.each_line do |player|
    first_name, last_name, position, team, age, date = player.chomp.split("|")
    date = /\/Date\((\d+)\)/.match(date)
    date_of_birth = Time.at(date[1].to_i/1000)
    position_id = Position.where(:position => position).first.id
    team_id = Team.where(:name => team).first.id
    Player.create({ :first_name => first_name, :last_name => last_name, :position_id => position_id,
                    :team_id => team_id, :age => age, :date_of_birth => date_of_birth }) 
  end
end

# Fantasy League Types
FantasyLeagueType.delete_all
FantasyLeagueType.create({ :league_type_description => "Head to Head", :league_type_code => "H2H" })
