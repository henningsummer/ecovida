class CreateDocuments < ActiveRecord::Migration
  def change
    create_table :documents do |t|
      t.string :name
      t.text :description
      t.string :subject
      t.string :upload_type
      t.string :status
      t.string :required_for_certificate

      t.timestamps null: false
    end
  end
end
