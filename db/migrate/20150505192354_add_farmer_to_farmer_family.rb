class AddFarmerToFarmerFamily < ActiveRecord::Migration
  def change
    add_reference :farmer_families, :farmer, index: true, foreign_key: true
  end
end
