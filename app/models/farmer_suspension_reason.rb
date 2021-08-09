# == Schema Information
#
# Table name: farmer_suspension_reasons
#
#  id                   :integer          not null, primary key
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  farmer_suspension_id :integer
#  suspension_type_id   :integer
#
# Indexes
#
#  index_farmer_suspension_reasons_on_farmer_suspension_id  (farmer_suspension_id)
#  index_farmer_suspension_reasons_on_suspension_type_id    (suspension_type_id)
#
# Foreign Keys
#
#  fk_rails_...  (farmer_suspension_id => farmer_suspensions.id)
#  fk_rails_...  (suspension_type_id => suspension_types.id)
#
class FarmerSuspensionReason < ActiveRecord::Base
  belongs_to :farmer_suspension
  belongs_to :suspension_type
end
