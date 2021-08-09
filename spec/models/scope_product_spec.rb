# == Schema Information
#
# Table name: scope_products
#
#  id                        :integer          not null, primary key
#  amount                    :float
#  amount_per_year           :float
#  amount_per_year_unity     :string
#  area                      :float
#  is_processor              :boolean
#  package_size              :float
#  package_size_unity        :string
#  unity                     :string
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#  product_id                :integer
#  production_unity_scope_id :integer
#
# Indexes
#
#  index_scope_products_on_product_id                 (product_id)
#  index_scope_products_on_production_unity_scope_id  (production_unity_scope_id)
#
# Foreign Keys
#
#  fk_rails_...  (product_id => products.id)
#  fk_rails_...  (production_unity_scope_id => production_unity_scopes.id)
#
require 'rails_helper'

RSpec.describe ScopeProduct, type: :model do
  subject{ build(:scope_product_agribusiness) }
  context 'validastions' do
    # it { is_expected.to validate_presence_of(:product_id) }
  end

  context 'associations' do
    # it { is_expected.to belong_to(:product) }
    # it { is_expected.to belong_to(:production_unity_scope) }
  end

  context 'factory' do
    it { expect(build(:scope_product_production_unity).valid?).to eq(true) }
    it { expect(build(:scope_product_agribusiness).valid?).to eq(true) }
    it { expect{create(:invalid_scope_product).valid?}.to raise_error }
  end
end
