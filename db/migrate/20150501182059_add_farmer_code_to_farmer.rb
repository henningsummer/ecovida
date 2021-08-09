class AddFarmerCodeToFarmer < ActiveRecord::Migration
  def change
    add_column :farmers, :farmer_code, :string
  end
end
