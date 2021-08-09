class CreateCores < ActiveRecord::Migration
  def change
    create_table :cores do |t|
      t.string :name
      t.string :login
      t.string :password_digest
      t.boolean :total_power, defualt: false
      t.timestamps null: false
    end
  end
end
