class CreateFarmerSuspensions < ActiveRecord::Migration
  def change
    create_table :farmer_suspensions do |t|
      t.string :description
      t.date :suspension_date
      t.string :suspension_type

      t.timestamps null: false
    end
  end
end
