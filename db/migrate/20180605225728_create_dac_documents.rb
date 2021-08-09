class CreateDacDocuments < ActiveRecord::Migration
  def change
    create_table :dac_documents do |t|
      t.references :group, index: true, foreign_key: true
      t.string :file
      t.date :dac_date
      t.string :status
      t.text :observations
      t.text :rejection_reason
      t.date :approved_at

      t.timestamps null: false
    end
  end
end
