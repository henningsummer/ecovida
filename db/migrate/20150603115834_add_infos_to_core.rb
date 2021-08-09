class AddInfosToCore < ActiveRecord::Migration
  def change
    add_column :cores, :email, :string
    add_column :cores, :phone, :string
  end
end
