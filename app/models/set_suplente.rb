# == Schema Information
#
# Table name: set_suplentes
#
#  id          :integer          not null, primary key
#  added_by    :string
#  description :text
#  set_type    :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  farmer_id   :integer
#  group_id    :integer
#
# Indexes
#
#  index_set_suplentes_on_farmer_id  (farmer_id)
#  index_set_suplentes_on_group_id   (group_id)
#
# Foreign Keys
#
#  fk_rails_...  (farmer_id => farmers.id)
#  fk_rails_...  (group_id => groups.id)
#
class SetSuplente < ActiveRecord::Base
  belongs_to :group
  belongs_to :farmer

  SUPLENTE_TYPES = [[''], ['Tornar suplente', 1], ['Tornar titular', 2]]

  validates_presence_of :farmer_id, :set_type
  validates :farmer_id, presence: true
  validates :set_type, presence: true
  validates :group_id, presence: true

  before_create do
  	group_to_change = Group.find(self.group_id)
  	if self.set_type == 1 #é suplente?
  		group_to_change.suplente_id = self.farmer.id
  	elsif self.set_type == 2 #é titular?
  		group_to_change.titular_id = self.farmer.id
  	end
  	group_to_change.save
  end
end
