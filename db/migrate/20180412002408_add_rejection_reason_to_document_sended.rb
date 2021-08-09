class AddRejectionReasonToDocumentSended < ActiveRecord::Migration
  def change
    add_column :document_sendeds, :rejection_reason, :text
  end
end
