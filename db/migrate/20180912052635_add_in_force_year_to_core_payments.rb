class AddInForceYearToCorePayments < ActiveRecord::Migration
  def change
    add_column :core_payments, :in_force_year, :integer
  end
end
