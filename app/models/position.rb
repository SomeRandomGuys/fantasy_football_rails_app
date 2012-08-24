# == Schema Information
#
# Table name: positions
#
#  id         :integer          not null, primary key
#  position   :string(255)
#  type       :string(255)
#  code       :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class Position < ActiveRecord::Base
end
