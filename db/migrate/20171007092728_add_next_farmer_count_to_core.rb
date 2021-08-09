class AddNextFarmerCountToCore < ActiveRecord::Migration
  def change
    add_column :cores, :next_farmer_count, :integer, default: 0
  end
end
