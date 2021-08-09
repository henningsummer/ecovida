class CreateGroups < ActiveRecord::Migration
  def change
    create_table :groups do |t|
      t.string :name, null: false
      t.references :core, index: true, foreign_key: true
      t.string :login, null: false
      t.string :password_digest

      t.timestamps null: false
    end
  end
end
