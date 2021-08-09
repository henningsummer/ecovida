class CreateCertificateFamilies < ActiveRecord::Migration
  def change
    create_table :certificate_families do |t|
      t.references :certificate, index: true, foreign_key: true
      t.string :name
      t.references :farmer_family, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
