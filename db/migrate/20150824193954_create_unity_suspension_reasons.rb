class CreateUnitySuspensionReasons < ActiveRecord::Migration
  def change
    create_table :unity_suspension_reasons do |t|
      t.references :unity_suspension, index: true, foreign_key: true
      t.references :unity_suspension_type, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
