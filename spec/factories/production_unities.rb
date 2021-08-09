# == Schema Information
#
# Table name: production_unities
#
#  id                  :integer          not null, primary key
#  address             :string
#  cep                 :string
#  email               :string
#  excluded            :boolean
#  excluded_with_group :boolean          default(FALSE)
#  fantasy_name        :string
#  lat_hour            :integer
#  lat_minute          :integer
#  lat_second          :decimal(, )
#  lat_type            :string
#  lon_hour            :integer
#  lon_minute          :integer
#  lon_second          :decimal(, )
#  lon_type            :string
#  name                :string
#  neighborhood        :string
#  number              :string
#  number_type         :integer
#  phone               :string
#  production_type     :string
#  register_number     :string
#  register_type       :string
#  scope_type          :integer
#  total_area          :string
#  total_native_area   :string
#  total_organic_area  :string
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  city_id             :integer
#  group_id            :integer
#
# Indexes
#
#  index_production_unities_on_city_id   (city_id)
#  index_production_unities_on_group_id  (group_id)
#
# Foreign Keys
#
#  fk_rails_...  (city_id => cities.id)
#  fk_rails_...  (group_id => groups.id)
#
require 'cpf_cnpj'

FactoryGirl.define do
  factory :production_unity do
    lon_hour { 20 }
    lon_minute { 20 }
    lon_second { 20 }
    lon_type { "L" }
    lat_hour { 20 }
    lat_minute { 20 }
    lat_second { 20 }
    lat_type { "N" }
    address {Faker::Address.street_name}
    cep 95560000
    city
    email {Faker::Internet.email}
    fantasy_name {Faker::Name.name}
    group
    name {Faker::Name.name}
    neighborhood {Faker::Address.street_name}
    production_type ['Orgânico', 'Biodinâmico', 'Em transição'].sample
    excluded false
  end

  factory :production_unity_normal, parent: :production_unity do
    scope_type 1
    total_native_area 10
    total_organic_area 10
    total_area 20
  end

  factory :cpf_agribusiness, parent: :production_unity do
    scope_type 2
    number_type 1
    number CPF.generate
    register_number '123456789'
    register_type 'Tipo de registro'
  end

  factory :cnpj_agribusiness, parent: :production_unity do
    scope_type 2
    number_type 2
    number CNPJ.generate
    register_type 'Tipo de registro '
    register_number '123456789'
  end

  factory :invalid_production_unity, parent: :production_unity do
    address nil
    cep nil
    city nil
    email nil
    fantasy_name nil
    group nil
    name nil
    neighborhood nil
    production_type nil
  end
end
