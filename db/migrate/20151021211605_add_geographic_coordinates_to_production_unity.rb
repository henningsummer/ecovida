class AddGeographicCoordinatesToProductionUnity < ActiveRecord::Migration
  def change
    add_column :production_unities, :lat_hour, :integer
    add_column :production_unities, :lat_minute, :integer
    add_column :production_unities, :lat_second, :integer
    add_column :production_unities, :lat_type, :string
    add_column :production_unities, :lon_hour, :integer
    add_column :production_unities, :lon_minute, :integer
    add_column :production_unities, :lon_second, :integer
    add_column :production_unities, :lon_type, :string
  end
end
