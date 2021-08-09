# == Schema Information
#
# Table name: unity_suspension_reasons
#
#  id                       :integer          not null, primary key
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#  unity_suspension_id      :integer
#  unity_suspension_type_id :integer
#
# Indexes
#
#  index_unity_suspension_reasons_on_unity_suspension_id       (unity_suspension_id)
#  index_unity_suspension_reasons_on_unity_suspension_type_id  (unity_suspension_type_id)
#
# Foreign Keys
#
#  fk_rails_...  (unity_suspension_id => unity_suspensions.id)
#  fk_rails_...  (unity_suspension_type_id => unity_suspension_types.id)
#
class UnitySuspensionReason < ActiveRecord::Base
  belongs_to :unity_suspension
  belongs_to :unity_suspension_type
end
