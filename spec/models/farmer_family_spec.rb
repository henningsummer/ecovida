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
require 'rails_helper'

RSpec.describe FarmerFamily, type: :model do
  context 'associations' do
    it { is_expected.to belong_to(:farmer) }
  end

  context 'factory' do
    it { expect(build(:farmer_family)).to be_valid }
    it { expect(build(:invalid_farmer_family)).to_not be_valid }
  end

  context 'validations' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:farmer_id) }
  end
end
