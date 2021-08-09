class CreateFarmerGroupChanges < ActiveRecord::Migration
  def change
    create_table :farmer_group_changes do |t|
      t.references :farmer, index: true, foreign_key: true
      t.references :group, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
