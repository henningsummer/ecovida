class ChangeExpectedDateToPaymentDateOnCorePayments < ActiveRecord::Migration
  def change
    rename_column :core_payments, :expected_date, :payment_date
  end
end
