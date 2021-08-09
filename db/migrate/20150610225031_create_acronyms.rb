class CreateAcronyms < ActiveRecord::Migration
  def change
    create_table :acronyms do |t|
      t.string :sign
      t.string :full_name

      t.timestamps null: false
    end
  end
end
