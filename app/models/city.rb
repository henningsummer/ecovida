# == Schema Information
#
# Table name: cities
#
#  id         :integer          not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  state_id   :integer
#
# Indexes
#
#  index_cities_on_state_id  (state_id)
#
# Foreign Keys
#
#  fk_rails_...  (state_id => states.id)
#
class City < ActiveRecord::Base
  belongs_to :state
  has_many :certificate_groups
  has_many :farmers
  validates_presence_of :name, :state_id

  scope :farmer_count_asc, -> { joins(:farmers).group('cities.id').order('count(cities.id) desc') }

  def self.get_cities_from_state(state_id)
    all.where(state_id: state_id).order(:name).collect {|c| [c.name, c.id]}
  end
end
