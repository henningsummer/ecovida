class AddPhoneAndEmailToProductionUnity < ActiveRecord::Migration
  def change
    add_column :production_unities, :phone, :string
    add_column :production_unities, :email, :string
    add_column :production_unities, :production_type, :string
  end
end
