class CreateSystemSettings < ActiveRecord::Migration
  def change
    create_table :system_settings do |t|
      t.decimal :basic_annuity_rate
      t.decimal :single_agribusiness_rate
      t.decimal :basic_propertyless_member_rate
      t.timestamps null: false
    end
  end
end
