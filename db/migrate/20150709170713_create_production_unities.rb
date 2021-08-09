class CreateProductionUnities < ActiveRecord::Migration
  def change
    create_table :production_unities do |t|
      t.string :fantasy_name
      t.string :name
      t.string :number
      t.string :register_type
      t.string :register_number
      t.string :address
      t.string :neighborhood
      t.references :city, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
