# == Schema Information
#
# Table name: farmer_group_changes
#
#  id         :integer          not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  farmer_id  :integer
#  group_id   :integer
#
# Indexes
#
#  index_farmer_group_changes_on_farmer_id  (farmer_id)
#  index_farmer_group_changes_on_group_id   (group_id)
#
# Foreign Keys
#
#  fk_rails_...  (farmer_id => farmers.id)
#  fk_rails_...  (group_id => groups.id)
#
class FarmerGroupChange < ActiveRecord::Base
  belongs_to :farmer
  belongs_to :group
  validate :validations

  before_create do 
    ActiveRecord::Base.transaction(joinable: false, requires_new: true) do
      @group = Group.find(self.group_id)
      @farmer = Farmer.find(self.farmer_id)
      @farmer.update(group_id: @group.id)

      changes = []
      changes << ["Mudança" => "Foi transferido de outro grupo para este."]
      @farmer.update_sig_org(changes)

      @farmer.production_unity_farmers.each do |puf|
        puf.production_unity.update(group_id: @group.id)
        changes = []
        changes << ["Mudança" => "Foi transferido de outro grupo para este."]
        puf.production_unity.update_sig_org(changes)
  	  end
    end
  end

  def validations
  	@group = Group.find(group_id)
  	@farmer = Farmer.find(farmer_id)
  	errors.add(:group_id, "Impossível mudar para o mesmo grupo") if @farmer.group.id == @group.id
  	errors.add(:group_id, "Impossível mudar para outro núcleo") if @farmer.group.core.id != @group.core.id
  	@farmer.production_unity_farmers.each do |puf|
  		errors.add(:group_id, "Impossível mudar de grupo.  Há unidade de produção com mais agricultores vinculados") if puf.production_unity.production_unity_farmers.count != 1
      errors.add(:group_id, "Impossível mudar de grupo,  Há propriedades ou agroindustrias inválidas") unless puf.production_unity.valid?
  	end
  end
end
