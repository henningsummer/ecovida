class CreateCertificateProducts < ActiveRecord::Migration
  def change
    create_table :certificate_products do |t|
      t.references :certificate, index: true, foreign_key: true
      t.boolean :contain_organic
      t.string :name
      t.references :product, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
