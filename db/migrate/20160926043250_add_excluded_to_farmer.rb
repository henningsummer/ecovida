class AddExcludedToFarmer < ActiveRecord::Migration
  def change
    add_column :farmers, :excluded, :boolean
  end
end
