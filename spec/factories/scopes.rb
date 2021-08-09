# == Schema Information
#
# Table name: scopes
#
#  id         :integer          not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  acronym    :string
#  scope_type :integer
#
FactoryGirl.define do
  factory :scope do
    name {Faker::Company.name}
    acronym {Faker::Company.suffix}
    scope_type [1, 2].sample
  end

  factory :invalid_scope, parent: :scope do
    name nil
    acronym nil
    scope_type nil
  end
end
