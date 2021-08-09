class ChangeIntegerToDecimalPu < ActiveRecord::Migration
  def change
    change_column :production_unities, :lat_second, :decimal
    change_column :production_unities, :lon_second, :decimal
  end
end
