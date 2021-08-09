class CreateSigorgs < ActiveRecord::Migration
  def change
    create_table :sigorgs do |t|
      t.references :farmer, index: true, foreign_key: true
      t.references :production_unity, index: true, foreign_key: true
      t.string :sig_org_type

      t.timestamps null: false
    end
  end
end
