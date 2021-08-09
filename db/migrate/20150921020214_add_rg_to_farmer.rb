class AddRgToFarmer < ActiveRecord::Migration
  def change
    add_column :farmers, :rg, :string
  end
end
