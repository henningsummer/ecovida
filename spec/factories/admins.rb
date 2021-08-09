# == Schema Information
#
# Table name: admins
#
#  id              :integer          not null, primary key
#  name            :string
#  login           :string           not null
#  password_digest :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
FactoryGirl.define do
  factory :admin do
    name { Faker::Name.name }
    login { |n| "admin#{n}" }
    password "12345678"
    password_confirmation "12345678"
  end

  factory :invalid_admin, parent: :admin do
    name nil
    login nil
    password nil
    password_confirmation nil
  end
end
