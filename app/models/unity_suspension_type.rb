# == Schema Information
#
# Table name: unity_suspension_types
#
#  id         :integer          not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class UnitySuspensionType < ActiveRecord::Base
  belongs_to :production_unity
  validates_presence_of :name
end
