class AddScopeTypeToScope < ActiveRecord::Migration
  def change
    add_column :scopes, :scope_type, :integer
  end
end
