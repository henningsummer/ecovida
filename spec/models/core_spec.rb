# == Schema Information
#
# Table name: cores
#
#  id                   :integer          not null, primary key
#  coordinator_email    :string
#  coordinator_name     :string
#  coordinator_phone    :string
#  email                :string
#  inactive_certificate :boolean          default(FALSE)
#  login                :string
#  name                 :string
#  next_farmer_count    :integer          default(0)
#  number_from_state    :integer
#  password_digest      :string
#  phone                :string
#  sig_org_access       :boolean
#  total_power          :boolean
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  state_id             :integer
#
# Indexes
#
#  index_cores_on_state_id  (state_id)
#
# Foreign Keys
#
#  fk_rails_...  (state_id => states.id)
#
require 'rails_helper'

RSpec.describe Core, :type => :model do
  context 'associations' do
    it { is_expected.to belong_to (:state) }

    it { is_expected.to have_many (:groups) }
    it { is_expected.to have_many (:core_coordinators)}
  end

  context "validations" do
    it { is_expected.to validate_presence_of (:name) }
    it { is_expected.to validate_presence_of (:login) }
    it { is_expected.to validate_presence_of (:email) }
    it { is_expected.to validate_presence_of (:state_id) }
    it { is_expected.to validate_presence_of (:phone) }

    # context "Uniqueness" do
    #   subject { create(:core) }
    #   it { is_expected.to validate_uniqueness_of (:name).scoped_to(:login)}
    #   it { is_expected.to validate_uniqueness_of (:login).scoped_to(:login)}
    # end
  end

  context 'factory' do
    it { expect(build(:core)).to be_valid }
    it { expect(build(:invalid_core)).to_not be_valid }
  end

  context "before_create" do
    it "Calculate number from state" do
      state_one = create(:state, uf: 'RS')
      state_two = create(:state, uf: 'SC')

      core_one = create(:core, state: state_one)
      core_two = create(:core, state: state_one)
      core_three = create(:core, state: state_two)

      expect(core_one.number_from_state).to eq(1)
      expect(core_two.number_from_state).to eq(2)
      expect(core_three.number_from_state).to eq(1)
    end
  end
end
