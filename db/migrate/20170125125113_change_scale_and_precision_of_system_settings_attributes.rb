class ChangeScaleAndPrecisionOfSystemSettingsAttributes < ActiveRecord::Migration
  def change
    change_column :system_settings, :basic_annuity_rate, :decimal, precision: 5, scale: 2
    change_column :system_settings, :single_agribusiness_rate, :decimal, precision: 5, scale: 2
    change_column :system_settings, :basic_propertyless_member_rate, :decimal, precision: 5, scale: 2
  end
end
