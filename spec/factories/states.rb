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
FactoryGirl.define do
  factory :state do
    name {Faker::Address.state}
    uf {Faker::Address.state_abbr}
  end

  factory :invalid_state, parent: :state do
    name nil
    uf nil
  end
end
