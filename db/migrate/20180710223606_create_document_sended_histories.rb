class CreateDocumentSendedHistories < ActiveRecord::Migration
  def change
    create_table :document_sended_histories do |t|
      t.references :document_sended, index: true, foreign_key: true
      t.string :file
      t.string :url
      t.date :approved_at

      t.timestamps null: false
    end
  end
end
