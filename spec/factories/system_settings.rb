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
FactoryGirl.define do
  factory :system_setting do
    basic_annuity_rate 0.00
	single_agribusiness_rate 0.00
	basic_propertyless_member_rate 0.00
  end
end
