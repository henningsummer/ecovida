# == Schema Information
#
# Table name: groups
#
#  id              :integer          not null, primary key
#  email           :string
#  excluded        :boolean          default(FALSE)
#  login           :string           not null
#  name            :string           not null
#  password_digest :string
#  phone           :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  core_id         :integer
#  group_type_id   :integer
#  suplente_id     :integer
#  titular_id      :integer
#
# Indexes
#
#  index_groups_on_core_id        (core_id)
#  index_groups_on_group_type_id  (group_type_id)
#
# Foreign Keys
#
#  fk_rails_...  (core_id => cores.id)
#  fk_rails_...  (group_type_id => group_types.id)
#
FactoryGirl.define do
  factory :group do
    email {Faker::Internet.email}
    group_type
    login {Faker::Internet.email}
    name {Faker::Name.name}
    password "12345678"
    password_confirmation "12345678"
    phone {Faker::PhoneNumber.phone_number}
    core
  end

  factory :invalid_group, parent: :group do
    email nil
    group_type nil
    login nil
    name nil
    password nil
    password_confirmation nil
    phone nil
    core nil
  end
end
