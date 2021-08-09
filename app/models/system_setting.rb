# == Schema Information
#
# Table name: system_settings
#
#  id                             :integer          not null, primary key
#  basic_annuity_rate             :decimal(8, 2)
#  single_agribusiness_rate       :decimal(8, 2)
#  basic_propertyless_member_rate :decimal(8, 2)
#  created_at                     :datetime         not null
#  updated_at                     :datetime         not null
#
class SystemSetting < ActiveRecord::Base
  include Convertable

  converts :basic_annuity_rate, to: :decimal
  converts :single_agribusiness_rate, to: :decimal
  converts :basic_propertyless_member_rate, to: :decimal

  def self.basic_rate
    first.basic_annuity_rate.to_f
  end

  def self.agribusiness_rate
    first.single_agribusiness_rate.to_f
  end

  def self.propertyless_rate
    first.basic_propertyless_member_rate.to_f
  end
end
