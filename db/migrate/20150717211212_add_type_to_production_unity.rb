class AddTypeToProductionUnity < ActiveRecord::Migration
  def change
    add_column :production_unities, :scope_type, :integer
  end
end
