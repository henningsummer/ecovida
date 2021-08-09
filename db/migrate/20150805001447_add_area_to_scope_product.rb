class AddAreaToScopeProduct < ActiveRecord::Migration
  def change
    add_column :scope_products, :area, :float
  end
end
