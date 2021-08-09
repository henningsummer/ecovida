# == Schema Information
#
# Table name: set_suplentes
#
#  id          :integer          not null, primary key
#  added_by    :string
#  description :text
#  set_type    :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  farmer_id   :integer
#  group_id    :integer
#
# Indexes
#
#  index_set_suplentes_on_farmer_id  (farmer_id)
#  index_set_suplentes_on_group_id   (group_id)
#
# Foreign Keys
#
#  fk_rails_...  (farmer_id => farmers.id)
#  fk_rails_...  (group_id => groups.id)
#
require 'rails_helper'

RSpec.describe SetSuplente, type: :model do
  context 'associations' do
    it { is_expected.to belong_to(:farmer) }
    it { is_expected.to belong_to(:group) }
  end

  context 'factory' do
    it { expect(build(:set_suplente)).to be_valid }
    it { expect(build(:invalid_set_suplente)).to_not be_valid }
  end

  context 'validations' do
    it { is_expected.to validate_presence_of(:farmer_id) }
    it { is_expected.to validate_presence_of(:group_id) }
    it { is_expected.to validate_presence_of(:set_type) }
  end

  context 'before_create' do
    let(:group) { FactoryGirl.create(:group) }
    let(:farmer) { FactoryGirl.create(:farmer, group: group) }

    # Set types
    # Para suplente = 1
    # Para titular = 2

    it "Set the group suplent" do
      create(:set_suplente, set_type: 1, farmer: farmer, group: group)

      group.reload

      expect(group.suplente).to eq(farmer)
    end

    it "Set the group titular" do
      create(:set_suplente, set_type: 2, farmer: farmer, group: group)

      group.reload

      expect(group.titular).to eq(farmer)
    end
  end
end
