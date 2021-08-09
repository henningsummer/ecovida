class AddGroupExcludedToFarmer < ActiveRecord::Migration
  def change
    add_column :farmers, :excluded_with_group, :boolean, default: false
  end
end
