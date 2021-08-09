class RemoveHasDocumentsFromFarmer < ActiveRecord::Migration
  def up
    remove_column :farmers, :has_documents
  end
  def down
    add_column :farmers, :has_documents
  end
end
