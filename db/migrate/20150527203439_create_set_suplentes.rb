class CreateSetSuplentes < ActiveRecord::Migration
  def change
    create_table :set_suplentes do |t|
      t.references :group, index: true, foreign_key: true
      t.references :farmer, index: true, foreign_key: true
      t.integer :set_type
      t.text :description
      t.string :added_by
      t.timestamps null: false
    end
  end
end
