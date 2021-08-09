class AddCordenadorToCore < ActiveRecord::Migration
  def change
    add_column :cores, :coordinator_name, :string
    add_column :cores, :coordinator_email, :string
    add_column :cores, :coordinator_phone, :string
  end
end
