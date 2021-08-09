class CreateCorePayment < ActiveRecord::Migration
  def change
    create_table :core_payments do |t|
      t.references :core, index: true, foreign_key: true
      t.decimal :amount, precision: 8, scale: 2
      t.date :expected_date
      t.string :description
    end
  end
end
