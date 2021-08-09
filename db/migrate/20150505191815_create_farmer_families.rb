class CreateFarmerFamilies < ActiveRecord::Migration
  def change
    create_table :farmer_families do |t|
      t.string :name
      t.string :cpf

      t.timestamps null: false
    end
  end
end
