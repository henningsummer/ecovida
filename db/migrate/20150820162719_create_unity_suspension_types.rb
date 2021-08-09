class CreateUnitySuspensionTypes < ActiveRecord::Migration
  def change
    create_table :unity_suspension_types do |t|
      t.string :name

      t.timestamps null: false
    end
  end
end
