class AddCityToCertificateGroup < ActiveRecord::Migration
  def change
    add_reference :certificate_groups, :city, index: true, foreign_key: true
  end
end
