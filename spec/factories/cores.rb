# == Schema Information
#
# Table name: cores
#
#  id                   :integer          not null, primary key
#  coordinator_email    :string
#  coordinator_name     :string
#  coordinator_phone    :string
#  email                :string
#  inactive_certificate :boolean          default(FALSE)
#  login                :string
#  name                 :string
#  next_farmer_count    :integer          default(0)
#  number_from_state    :integer
#  password_digest      :string
#  phone                :string
#  sig_org_access       :boolean
#  total_power          :boolean
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  state_id             :integer
#
# Indexes
#
#  index_cores_on_state_id  (state_id)
#
# Foreign Keys
#
#  fk_rails_...  (state_id => states.id)
#
FactoryGirl.define do
  factory :core do
    coordinator_email   {Faker::Internet.email}
  coordinator_name      {Faker::Name.name}
 coordinator_phone      {Faker::PhoneNumber.phone_number}
 password               "12345678"
 password_confirmation  "12345678"
             email      {Faker::Internet.email}
             login      {Faker::Internet.email}
              name      {Faker::Name.name}
             phone      {Faker::PhoneNumber.phone_number}
    sig_org_access      [true, false].sample
        state
       total_power      [true, false].sample
       next_farmer_count 0
  end

  factory :invalid_core, parent: :core do
    coordinator_email   nil
  coordinator_name      nil
 coordinator_phone      nil
 password               nil
             login      nil
              name      nil
             phone      nil
    sig_org_access      nil
        state          nil
       total_power      nil
  end
end
