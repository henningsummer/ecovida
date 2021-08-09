class CreateCertificateAddresses < ActiveRecord::Migration
  def change
    create_table :certificate_addresses do |t|
      t.references :certificate, index: true, foreign_key: true
      t.string :address

      t.timestamps null: false
    end
  end
end
