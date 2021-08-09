# == Schema Information
#
# Table name: core_payments
#
#  id            :integer          not null, primary key
#  amount        :decimal(8, 2)
#  description   :string
#  in_force_year :integer
#  payment_date  :date
#  core_id       :integer
#
# Indexes
#
#  index_core_payments_on_core_id  (core_id)
#
# Foreign Keys
#
#  fk_rails_...  (core_id => cores.id)
#
class CorePayment < ActiveRecord::Base
  include Convertable

  belongs_to :core
  validates_presence_of :amount, :payment_date, :description, :core_id
  # validate :payment_limit
  validates :in_force_year,
  presence: true,
  inclusion: { in: Date.today.year-20..Date.today.year },
  format: {
    with: /(19|20)\d{2}/i,
    message: "deve conter 4 digitos"
  }

  converts :amount, to: :decimal

  def self.search_by_year(year)
    ransack({
      in_force_year_eq: year
    })
  end

  private

  def payment_limit
    year = in_force_year
    summarized = core.summarizing(year)
    payed = core.core_payments.search_by_year(year).result(distinct: true).map(&:amount).reduce(:+).to_f
    to_pay =  summarized[:amount] - payed
    if amount.to_f > to_pay
      to_pay_to_s = to_pay.round(2).to_s.gsub('.',',')
      errors.add(:amount,
        "Valor pago informado é maior que o valor a pagar. O valor a pagar é de R$ #{to_pay_to_s}"
      )
    end
  end
end
