class AddLembreteToFarmer < ActiveRecord::Migration
  def change
    add_column :farmers, :lembrete, :text
  end
end
