class AddCertificateNumberTypeToCertificate < ActiveRecord::Migration
  def change
    add_column :certificates, :number_type, :string
  end
end
