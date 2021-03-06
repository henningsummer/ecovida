# == Schema Information
#
# Table name: suspension_types
#
#  id         :integer          not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class SuspensionType < ActiveRecord::Base
  validates_presence_of :name
end
