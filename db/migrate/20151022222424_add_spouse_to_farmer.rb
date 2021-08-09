class AddSpouseToFarmer < ActiveRecord::Migration
  def change
    add_column :farmers, :spouse, :string
    add_column :farmers, :spouse_cpf, :string
  end
end
