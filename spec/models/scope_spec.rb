# == Schema Information
#
# Table name: scopes
#
#  id         :integer          not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  acronym    :string
#  scope_type :integer
#
require 'rails_helper'

RSpec.describe Scope, type: :model do
  context 'associations' do
    it { is_expected.to have_many(:product_categories) }
  end

  context 'validations' do
    it { is_expected.to validate_presence_of :name }
    it { is_expected.to validate_presence_of :acronym }
  end

  context 'factory' do
    it { expect(build(:scope)).to be_valid }
    it { expect(build(:invalid_scope)).to_not be_valid }
  end
end
