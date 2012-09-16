# == Schema Information
#
# Table name: teams
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  code       :string(255)
#  league_id  :integer
#  home_field :string(255)
#  city       :string(255)
#  created_at :datetime
#  updated_at :datetime
#

# == Schema Information
#
# Table name: teams
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  code       :string(255)
#  league_id  :integer
#  home_field :string(255)
#  city       :string(255)
#  created_at :datetime
#  updated_at :datetime
#
class Team < ActiveRecord::Base
  has_many :players
end
