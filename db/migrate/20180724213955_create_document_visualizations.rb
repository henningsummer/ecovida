class CreateDocumentVisualizations < ActiveRecord::Migration
  def change
    create_table :document_visualizations do |t|
      t.string :access_key
      t.datetime :expire_at

      t.timestamps null: false
    end
  end
end
