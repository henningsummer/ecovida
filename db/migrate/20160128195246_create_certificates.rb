class CreateCertificates < ActiveRecord::Migration
  def change
    create_table :certificates do |t|
      t.string :certificate_type
      t.references :certificate_group, index: true, foreign_key: true
      t.integer :pruduction_quantity

      t.timestamps null: false
    end
  end
end
