class CreateDocumentSendedStatuses < ActiveRecord::Migration
  def change
    create_table :document_sended_statuses do |t|
      t.references :document_sended, index: true, foreign_key: true
      t.string :status
      t.string :reason

      t.timestamps null: false
    end
  end
end
