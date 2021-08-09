class AddExcludedToGroup < ActiveRecord::Migration
  def change
    add_column :groups, :excluded, :boolean, default: false
  end
end
