# == Schema Information
#
# Table name: farmer_families
#
#  id         :integer          not null, primary key
#  birthday   :date
#  cpf        :string
#  gender     :string
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  farmer_id  :integer
#
# Indexes
#
#  index_farmer_families_on_farmer_id  (farmer_id)
#
# Foreign Keys
#
#  fk_rails_...  (farmer_id => farmers.id)
#
require 'cpf_cnpj'

FactoryGirl.define do
  factory :farmer_family do
    farmer
    name { Faker::Name.name }
    cpf { CPF.generate }
  end

  factory :invalid_farmer_family, parent: :farmer_family do
    farmer nil
    name nil
    cpf nil
  end
end
