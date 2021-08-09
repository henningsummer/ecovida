class AddScopeToProductCategory < ActiveRecord::Migration
  def change
    add_reference :product_categories, :scope, index: true, foreign_key: true
  end
end
