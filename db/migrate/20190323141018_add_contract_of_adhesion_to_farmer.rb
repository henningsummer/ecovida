class AddContractOfAdhesionToFarmer < ActiveRecord::Migration
  def change
    add_column :farmers, :contract_of_adhesion, :boolean, default: false

    Farmer.update_all(contract_of_adhesion: false)
  end
end
