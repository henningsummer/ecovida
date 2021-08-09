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
FactoryGirl.define do
  factory :city do
    name { Faker::Address.city }
    association :state
  end

  factory :invalid_city, parent: :city do
    name nil
    state nil
  end
end
