class CreateScopes < ActiveRecord::Migration
  def change
    create_table :scopes do |t|
      t.string :name
      t.references :acronym, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
