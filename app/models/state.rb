# == Schema Information
#
# Table name: states
#
#  id         :integer          not null, primary key
#  name       :string           not null
#  uf         :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class State < ActiveRecord::Base
  has_many :cities
  has_many :cores
  validates :name, presence: true

  def self.to_select
    states = ['']
    states+= all.collect{|c| ["#{c.name} - #{c.uf}", c.id]}
    states
  end
end
