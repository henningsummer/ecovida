class RemoveColumnsFromSetSuplentes < ActiveRecord::Migration
  def up
  	remove_column :set_suplentes, :current_user
  	remove_column :set_suplentes, :user_type
  end
  def down
  	add_column :set_suplentes, :current_user
  	add_column :set_suplentes, :user_type
  end
end
