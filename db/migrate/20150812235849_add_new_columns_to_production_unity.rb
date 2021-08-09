class AddNewColumnsToProductionUnity < ActiveRecord::Migration
  def change
    add_column :production_unities, :geographic_coordinates, :string
    add_column :production_unities, :total_area, :string
    add_column :production_unities, :total_organic_area, :string
    add_column :production_unities, :total_native_area, :string
  end
end
