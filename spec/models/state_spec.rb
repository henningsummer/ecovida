# == Schema Information
#
# Table name: states
#
#  id         :integer          not null, primary key
#  name       :string           not null
#  uf         :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
require 'rails_helper'

RSpec.describe State, :type => :model do
 context 'validations' do
   it { is_expected.to validate_presence_of :name }
 end

 context 'factory' do
   it { expect(build(:state)).to be_valid }
   it { expect(build(:invalid_state)).to_not be_valid }
 end
end
