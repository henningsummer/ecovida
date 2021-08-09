class AddNumberTypeToProductionUnity < ActiveRecord::Migration
  def change
    add_column :production_unities, :number_type, :integer
  end
end
