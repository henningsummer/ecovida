class CreateUnitySuspensions < ActiveRecord::Migration
  def change
    create_table :unity_suspensions do |t|
      t.string :description
      t.date :suspension_date
      t.references :production_unity, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
