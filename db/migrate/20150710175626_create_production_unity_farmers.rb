class CreateProductionUnityFarmers < ActiveRecord::Migration
  def change
    create_table :production_unity_farmers do |t|
      t.references :farmer, index: true, foreign_key: true
      t.references :production_unity, index: true, foreign_key: true
      t.boolean :is_responsible

      t.timestamps null: false
    end
  end
end
