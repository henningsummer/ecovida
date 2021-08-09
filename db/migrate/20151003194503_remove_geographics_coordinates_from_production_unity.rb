class RemoveGeographicsCoordinatesFromProductionUnity < ActiveRecord::Migration
  def up
    remove_column :production_unities, :geographic_coordinates
  end
  def down
    add_column :production_unities, :geographic_coordinates, :string
  end
end
