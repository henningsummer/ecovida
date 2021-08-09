class CreateFarmerSuspensionReasons < ActiveRecord::Migration
  def change
    create_table :farmer_suspension_reasons do |t|
      t.references :farmer_suspension, index: true, foreign_key: true
      t.references :suspension_type, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
