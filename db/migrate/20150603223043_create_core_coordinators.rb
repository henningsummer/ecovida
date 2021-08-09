class CreateCoreCoordinators < ActiveRecord::Migration
  def change
    create_table :core_coordinators do |t|
      t.string :name
      t.string :email
      t.string :phone
      t.references :core, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
