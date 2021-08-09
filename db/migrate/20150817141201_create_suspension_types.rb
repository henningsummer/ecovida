class CreateSuspensionTypes < ActiveRecord::Migration
  def change
    create_table :suspension_types do |t|
      t.string :name

      t.timestamps null: false
    end
  end
end
