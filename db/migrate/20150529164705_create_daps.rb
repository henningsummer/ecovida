class CreateDaps < ActiveRecord::Migration
  def change
    create_table :daps do |t|
      t.string :dap_number
      t.date :validity
      t.date :emission_date
      t.string :added_by
      t.references :farmer, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
