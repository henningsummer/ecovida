class AddCepToProductionUnity < ActiveRecord::Migration
  def change
    add_column :production_unities, :cep, :string
  end
end
