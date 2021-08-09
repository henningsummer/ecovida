# == Schema Information
#
# Table name: product_categories
#
#  id         :integer          not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  scope_id   :integer
#
# Indexes
#
#  index_product_categories_on_scope_id  (scope_id)
#
# Foreign Keys
#
#  fk_rails_...  (scope_id => scopes.id)
#
require 'rails_helper'

RSpec.describe ProductCategory, type: :model do
  context 'associations' do
    it { is_expected.to belong_to :scope }

    it { is_expected.to have_many :products }
  end

  context 'factory' do
    it { expect(build(:product_category_for_agribusiness)).to be_valid }
    it { expect(build(:product_category_for_production_unity)).to be_valid }
    it { expect(build(:invalid_product_category)).to_not be_valid }
  end

  context 'associations' do
    it { is_expected.to validate_presence_of :name }
    it { is_expected.to validate_presence_of :scope_id }
  end
end
