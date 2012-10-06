desc "Update scores"
task :update_scores => :environment do
  FantasyWeeklyScores.test
end