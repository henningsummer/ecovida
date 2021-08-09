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
FactoryGirl.define do
  factory :product do
    name {Faker::Commerce.product_name}
    product_category { create ([:product_category_for_agribusiness,
                                :product_category_for_production_unity].sample) }
  end

  factory :invalid_product, parent: :product do
    name nil
    product_category nil
  end
end
