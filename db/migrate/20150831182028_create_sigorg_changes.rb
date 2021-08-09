class CreateSigorgChanges < ActiveRecord::Migration
  def change
    create_table :sigorg_changes do |t|
      t.references :sigorg, index: true, foreign_key: true
      t.string :changed_column
      t.string :value
      t.date :change_date

      t.timestamps null: false
    end
  end
end
