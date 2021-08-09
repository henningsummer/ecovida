class AddGenderAndBirthdayToFarmer < ActiveRecord::Migration
  def change
    add_column :farmers, :gender, :string
    add_column :farmers, :birthday, :date
  end
end
