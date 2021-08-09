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
require 'rails_helper'

RSpec.describe SystemSetting, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
