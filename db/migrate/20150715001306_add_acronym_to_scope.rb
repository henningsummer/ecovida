class AddAcronymToScope < ActiveRecord::Migration
  def change
    add_column :scopes, :acronym, :string
  end
end
