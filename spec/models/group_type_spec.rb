# == Schema Information
#
# Table name: group_types
#
#  id          :integer          not null, primary key
#  description :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
require 'rails_helper'

RSpec.describe GroupType, type: :model do
  context 'associations' do
    it { is_expected.to have_many(:groups) }
  end

  context 'factory' do
    it { expect(build(:group_type)).to be_valid }
    it { expect(build(:invalid_group_type)).to_not be_valid }
  end

  context 'validations' do
    it { is_expected.to validate_presence_of :description }
  end
end
