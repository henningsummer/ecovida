# == Schema Information
#
# Table name: cities
#
#  id         :integer          not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  state_id   :integer
#
# Indexes
#
#  index_cities_on_state_id  (state_id)
#
# Foreign Keys
#
#  fk_rails_...  (state_id => states.id)
#
require 'rails_helper'

RSpec.describe City, type: :model do
  context 'factory' do
    it { expect(build(:city)).to be_valid }
    it { expect(build(:invalid_city)).to_not be_valid }
  end
end
