# == Schema Information
#
# Table name: admins
#
#  id              :integer          not null, primary key
#  name            :string
#  login           :string           not null
#  password_digest :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
require 'rails_helper'

RSpec.describe Admin, type: :model do
  context 'validations' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:login) }
  end

  context 'factory' do
    it { expect(build(:admin)).to be_valid }
    it { expect(build(:invalid_admin)).to_not be_valid }
  end
end
