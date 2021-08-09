class AddSpouseInfosToFarmer < ActiveRecord::Migration
  def change
    add_column :farmers, :spouse_birthday, :date
    add_column :farmers, :spouse_gender, :string
  end
end
