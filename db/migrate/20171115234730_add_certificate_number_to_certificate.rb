class AddCertificateNumberToCertificate < ActiveRecord::Migration
  def change
    add_column :certificates, :number, :string
  end
end
