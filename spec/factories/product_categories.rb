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
FactoryGirl.define do
  factory :product_category do
    name { |n| "Categorio nº#{n}"}
  end

  factory :product_category_for_agribusiness, parent: :product_category do
    scope_id { create(:scope, scope_type: 2).id }
  end

  factory :product_category_for_production_unity, parent: :product_category do
    scope_id { create(:scope, scope_type: 2).id }
  end

  factory :invalid_product_category, parent: :product_category do
    name nil
    scope_id nil
  end
end
