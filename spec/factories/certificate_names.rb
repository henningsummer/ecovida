# == Schema Information
#
# Table name: certificate_names
#
#  id                  :integer          not null, primary key
#  farmer_code         :string
#  name                :string
#  name_type           :string
#  number              :string
#  number_type         :integer
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  certificate_id      :integer
#  farmer_id           :integer
#  production_unity_id :integer
#
# Indexes
#
#  index_certificate_names_on_certificate_id       (certificate_id)
#  index_certificate_names_on_farmer_id            (farmer_id)
#  index_certificate_names_on_production_unity_id  (production_unity_id)
#
# Foreign Keys
#
#  fk_rails_...  (certificate_id => certificates.id)
#  fk_rails_...  (farmer_id => farmers.id)
#  fk_rails_...  (production_unity_id => production_unities.id)
#
FactoryGirl.define do
  factory :certificate_name do
    
  end
end
