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
require 'rails_helper'

RSpec.describe ProductionUnityFarmer, type: :model do
  context 'validations' do
    it { is_expected.to validate_presence_of :farmer_id }
    it { is_expected.to validate_presence_of :production_unity_id }
  end

  context 'factory' do
    it { expect(build(:production_unity_farmer)).to be_valid }
    it { expect(build(:invalid_production_unity_farmer)).to_not be_valid }
  end

  context 'associations' do
    it { is_expected.to belong_to :farmer }
    it { is_expected.to belong_to :production_unity }
  end
end
