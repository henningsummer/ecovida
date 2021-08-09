# == Schema Information
#
# Table name: production_unity_farmers
#
#  id                  :integer          not null, primary key
#  is_responsible      :boolean
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  farmer_id           :integer
#  production_unity_id :integer
#
# Indexes
#
#  index_production_unity_farmers_on_farmer_id            (farmer_id)
#  index_production_unity_farmers_on_production_unity_id  (production_unity_id)
#
# Foreign Keys
#
#  fk_rails_...  (farmer_id => farmers.id)
#  fk_rails_...  (production_unity_id => production_unities.id)
#
FactoryGirl.define do
  factory :production_unity_farmer do
    production_unity { create([:production_unity_normal,
                               :cpf_agribusiness,
                               :cnpj_agribusiness].sample) }
    is_responsible [true, false].sample
    farmer
  end

  factory :invalid_production_unity_farmer, parent: :production_unity_farmer do
    production_unity nil
    is_responsible nil
    farmer nil
  end
end
