# == Schema Information
#
# Table name: groups
#
#  id              :integer          not null, primary key
#  email           :string
#  excluded        :boolean          default(FALSE)
#  login           :string           not null
#  name            :string           not null
#  password_digest :string
#  phone           :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  core_id         :integer
#  group_type_id   :integer
#  suplente_id     :integer
#  titular_id      :integer
#
# Indexes
#
#  index_groups_on_core_id        (core_id)
#  index_groups_on_group_type_id  (group_type_id)
#
# Foreign Keys
#
#  fk_rails_...  (core_id => cores.id)
#  fk_rails_...  (group_type_id => group_types.id)
#
require 'rails_helper'

RSpec.describe Group, type: :model do
  context 'Queries and functions' do

  end

  context 'factory' do
    it { expect(build(:group)).to be_valid }
    it { expect(build(:invalid_group)).to_not be_valid }
  end

  context 'associations' do
    it { is_expected.to have_many(:farmers) }
    it { is_expected.to have_many(:certificate_groups) }
    it { is_expected.to have_many(:production_unities) }
    it { is_expected.to have_many(:set_suplentes) }

    it { is_expected.to belong_to(:core) }
    it { is_expected.to belong_to(:group_type) }
  end
  context 'validations' do
    subject { create(:group) }
    it { is_expected.to validate_presence_of(:login) }
    it { is_expected.to validate_presence_of(:core_id) }
    it { is_expected.to validate_presence_of(:group_type_id) }

    it { is_expected.to validate_uniqueness_of(:login) }
    it { is_expected.to validate_uniqueness_of(:name) }
  end
end
