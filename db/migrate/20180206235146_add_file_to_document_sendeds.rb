class AddFileToDocumentSendeds < ActiveRecord::Migration
  def change
    add_column :document_sendeds, :file, :string
  end
end
