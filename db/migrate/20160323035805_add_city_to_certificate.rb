class AddCityToCertificate < ActiveRecord::Migration
  def change
    add_column :certificates, :city_name, :string
  end
end
