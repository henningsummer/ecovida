# == Schema Information
#
# Table name: daps
#
#  id            :integer          not null, primary key
#  added_by      :string
#  dap_number    :string
#  emission_date :date
#  validity      :date
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  farmer_id     :integer
#
# Indexes
#
#  index_daps_on_farmer_id  (farmer_id)
#
# Foreign Keys
#
#  fk_rails_...  (farmer_id => farmers.id)
#
require 'rails_helper'

RSpec.describe Dap, type: :model do
  context 'associations' do
    it { is_expected.to belong_to(:farmer) }
  end

  context 'factory' do
    it { expect(build(:dap)).to be_valid }
    it { expect(build(:invalid_dap)).to_not be_valid }
  end

  context 'validations' do
    subject { build(:dap) }
    it { is_expected.to validate_presence_of(:dap_number) }
    it { is_expected.to validate_presence_of(:emission_date) }
    it { is_expected.to validate_presence_of(:farmer_id) }
    it { is_expected.to validate_presence_of(:validity) }

    it "Can't save with validity equal or less than emission date" do
      expect(build(:invalid_validity_dap)).to_not be_valid
      expect(build(:dap)).to be_valid
    end
  end

end
