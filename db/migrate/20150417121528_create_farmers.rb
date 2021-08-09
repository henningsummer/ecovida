class CreateFarmers < ActiveRecord::Migration
  def change
    create_table :farmers do |t|
      t.string :name
      t.integer :number_type
      t.string :number
      t.boolean :has_documents
      t.string :address
      t.string :neighborhood
      t.references :city, index: true, foreign_key: true
      t.string :phone_number
      t.string :cell_phone
      t.string :email
      t.references :group, index: true, foreign_key: true
      t.boolean :suspended

      t.timestamps null: false
    end
  end
end
