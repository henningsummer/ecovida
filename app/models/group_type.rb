# == Schema Information
#
# Table name: group_types
#
#  id          :integer          not null, primary key
#  description :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
class GroupType < ActiveRecord::Base
  has_many :groups
  validates_uniqueness_of :description
  validates_presence_of(:description)
end
