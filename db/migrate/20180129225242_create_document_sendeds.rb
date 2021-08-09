class CreateDocumentSendeds < ActiveRecord::Migration
  def change
    create_table :document_sendeds do |t|
      t.references :document, index: true, foreign_key: true
      t.references :subject, polymorphic: true, index: true
      t.string :status
      t.string :approved_at
      t.string :url
      t.text :observations


      t.timestamps null: false
    end
  end
end
