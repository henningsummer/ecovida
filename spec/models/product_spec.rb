# == Schema Information
#
# Table name: products
#
#  id                  :integer          not null, primary key
#  name                :string
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  product_category_id :integer
#
# Indexes
#
#  index_products_on_product_category_id  (product_category_id)
#
# Foreign Keys
#
#  fk_rails_...  (product_category_id => product_categories.id)
#
require 'rails_helper'

RSpec.describe Product, type: :model do
  context "assoaciations" do
    it { is_expected.to belong_to :product_category }
  end

  context 'factory' do
    it { expect(build(:product)).to be_valid }
    it { expect(build(:invalid_product)).to_not be_valid }
  end

  context "validations" do
    it { is_expected.to validate_presence_of :name }
    it { is_expected.to validate_presence_of :product_category_id }
  end
end
