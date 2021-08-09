# == Schema Information
#
# Table name: farmers
#
#  id                   :integer          not null, primary key
#  address              :string
#  birthday             :date
#  cell_phone           :string
#  contract_of_adhesion :boolean          default(FALSE)
#  em_ata               :boolean
#  email                :string
#  excluded             :boolean
#  excluded_with_group  :boolean          default(FALSE)
#  farmer_code          :string
#  gender               :string
#  lembrete             :text
#  name                 :string
#  neighborhood         :string
#  number               :string
#  number_type          :integer
#  phone_number         :string
#  rg                   :string
#  spouse               :string
#  spouse_birthday      :date
#  spouse_cpf           :string
#  spouse_gender        :string
#  suspended            :boolean
#  termo_compromisso    :boolean
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  city_id              :integer
#  group_id             :integer
#
# Indexes
#
#  index_farmers_on_city_id   (city_id)
#  index_farmers_on_group_id  (group_id)
#
# Foreign Keys
#
#  fk_rails_...  (city_id => cities.id)
#  fk_rails_...  (group_id => groups.id)
#
require 'cpf_cnpj'

FactoryGirl.define do
  factory :farmer do
    address { Faker::Address.street_name }
    cell_phone { Faker::PhoneNumber.phone_number }
    association :city
    em_ata {[true, false].sample}
    email { Faker::Internet.email }
    association :group
    neighborhood { Faker::Address.street_name }
    name { Faker::Name.name }
    number {CPF.generate}
    number_type 1
    suspended false
    termo_compromisso { [false, true].sample }
  end

  factory :farmer_with_spouse, parent: :farmer do
    spouse { Faker::Name.name }
    spouse_cpf {CPF.generate}
  end

  factory :invalid_farmer, parent: :farmer do
    address nil
    cell_phone nil
    city nil
    em_ata nil
    email nil
    group nil
    neighborhood nil
    name nil
    number nil
    suspended nil
    termo_compromisso nil
  end
end
