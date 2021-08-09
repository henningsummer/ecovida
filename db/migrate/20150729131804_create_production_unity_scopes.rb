class CreateProductionUnityScopes < ActiveRecord::Migration
  def change
    create_table :production_unity_scopes do |t|
      t.references :scope, index: true, foreign_key: true
      t.references :production_unity, index: true, foreign_key: true
      t.float :total_area
      t.float :organic_production_area
      t.float :bushland_area

      t.timestamps null: false
    end
  end
end
