# == Schema Information
#
# Table name: dacs
#
#  id         :integer          not null, primary key
#  added_by   :string
#  dac_date   :date
#  sampling   :boolean
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  farmer_id  :integer
#
# Indexes
#
#  index_dacs_on_farmer_id  (farmer_id)
#
# Foreign Keys
#
#  fk_rails_...  (farmer_id => farmers.id)
#
require 'rails_helper'
RSpec.describe Dac, type: :model do
  context 'associations' do
    it { is_expected.to belong_to(:farmer) }
  end

  context 'factory' do
    it { expect(build(:dac)).to be_valid }
    it { expect(build(:invalid_dac)).to_not be_valid }
  end

  context 'validations' do
    it { is_expected.to validate_presence_of(:dac_date) }
    it { is_expected.to validate_presence_of(:farmer_id) }
  end
end
