class AddTitularESuplenteToGroup < ActiveRecord::Migration
  def change
    add_column :groups, :titular_id, :integer
    add_column :groups, :suplente_id, :integer
  end
end
