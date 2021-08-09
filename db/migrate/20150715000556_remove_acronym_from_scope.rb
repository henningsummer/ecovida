class RemoveAcronymFromScope < ActiveRecord::Migration
  def up
    remove_column :scopes, :acronym_id
  end
  def down
    add_column :scopes, :acronym, index: true, foreign_key: true
  end
end
