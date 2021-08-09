class AddGroupExcludedToProductionUnity < ActiveRecord::Migration
  def change
    add_column :production_unities, :excluded_with_group, :boolean, default: false
  end
end
