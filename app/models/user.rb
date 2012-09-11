# == Schema Information
#
# Table name: users
#
#  id         :integer          not null, primary key
#  username   :string(255)
#  first_name :string(255)
#  last_name  :string(255)
#  created_at :datetime
#  updated_at :datetime
#  password   :string(255)
#  email      :string(255)
#

class User < ActiveRecord::Base
  
  validates :username, :presence => true
  validates :password, :presence => true
  validates :email, :presence => true
  belongs_to :user_fantasy_manager
  
  def self.authenticate(username, password)
    user = find_by_username(username)
    return nil if user.nil?
    return user if user.password == password
  end
  
end
