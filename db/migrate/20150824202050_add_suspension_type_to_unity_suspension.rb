class AddSuspensionTypeToUnitySuspension < ActiveRecord::Migration
  def change
    add_column :unity_suspensions, :suspension_type, :string
  end
end
