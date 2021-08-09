class AddGenderAndBirthdayToFarmerFamily < ActiveRecord::Migration
  def change
    add_column :farmer_families, :gender, :string
    add_column :farmer_families, :birthday, :date
  end
end
