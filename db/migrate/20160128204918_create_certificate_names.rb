class CreateCertificateNames < ActiveRecord::Migration
  def change
    create_table :certificate_names do |t|
      t.string :name
      t.references :farmer, index: true, foreign_key: true
      t.references :production_unity, index: true, foreign_key: true
      t.references :certificate, index: true, foreign_key: true
      t.string :name_type

      t.timestamps null: false
    end
  end
end
