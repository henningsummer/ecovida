class AddNumberFromStateToCore < ActiveRecord::Migration
  def change
    add_column :cores, :number_from_state, :integer
  end
end
