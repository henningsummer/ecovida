class AddFarmerCodeToCertificateName < ActiveRecord::Migration
  def change
    add_column :certificate_names, :farmer_code, :string
  end
end
