class CreateScopeProducts < ActiveRecord::Migration
  def change
    create_table :scope_products do |t|
      t.float :amount
      t.string :unity
      t.float :package_size
      t.string :package_size_unity
      t.float :amount_per_year
      t.string :amount_per_year_unity
      t.references :product, index: true, foreign_key: true
      t.references :production_unity_scope, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
