class CreateDacs < ActiveRecord::Migration
  def change
    create_table :dacs do |t|
      t.date :dac_date
      t.boolean :sampling
      t.references :farmer, index: true, foreign_key: true
      t.string :added_by

      t.timestamps null: false
    end
  end
end
