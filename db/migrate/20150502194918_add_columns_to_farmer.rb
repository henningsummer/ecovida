class AddColumnsToFarmer < ActiveRecord::Migration
  def change
    add_column :farmers, :em_ata, :boolean
    add_column :farmers, :termo_compromisso, :boolean
  end
end
