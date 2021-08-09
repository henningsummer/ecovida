class CreateCertificateGroups < ActiveRecord::Migration
  def change
    create_table :certificate_groups do |t|
      t.string :meeting_number
      t.integer :meeting_page
      t.date :meeting_date
      t.references :group, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
