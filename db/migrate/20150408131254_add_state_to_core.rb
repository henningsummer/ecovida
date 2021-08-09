class AddStateToCore < ActiveRecord::Migration
  def change
    add_reference :cores, :state, index: true, foreign_key: true
  end
end
