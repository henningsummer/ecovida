class AddFarmerToFarmerSuspension < ActiveRecord::Migration
  def change
    add_reference :farmer_suspensions, :farmer, index: true, foreign_key: true
  end
end
