class SetCorePaymentsInforceYearWhereIsNull < ActiveRecord::Migration
  def change
    execute <<-SQL
      UPDATE core_payments  set in_force_year = extract(year from payment_date) where in_force_year is null;
    SQL
  end
end
