class AddExcludedToProductionUnity < ActiveRecord::Migration
  def change
    add_column :production_unities, :excluded, :boolean
  end
end
