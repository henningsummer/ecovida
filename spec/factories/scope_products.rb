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
FactoryGirl.define do
  factory :scope_product do
  end

  factory :scope_product_agribusiness, parent: :scope_product do
    production_unity_scope { create(:producion_unity_scope_to_agribusiness) }
    product { create(:product,
                      product_category: FactoryGirl.create(:product_category_for_agribusiness)) }

    package_size { (1..10).to_a.sample }
    package_size_unity { ScopeProduct.UNITIES.sample }
    amount_per_year { (1..10).to_a.sample }
    amount_per_year_unity { ScopeProduct.UNITIES.sample }
    is_processor { [true, false].sample }
  end

  factory :scope_product_production_unity, parent: :scope_product do
    production_unity_scope { create(:production_unity_scope_to_production_unity) }
    amount { (1..10).to_a.sample }
    unity { ScopeProduct.UNITIES.sample }
    area { (1..10).to_a.sample }
    product { create(:product,
                      product_category: FactoryGirl.create(:product_category_for_production_unity)) }
  end

  factory :invalid_scope_product, parent: :scope_product do
    product_id nil
    production_unity { create(:production_unity_scope_to_production_unity) }
  end
end
