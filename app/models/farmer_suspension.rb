# == Schema Information
#
# Table name: farmer_suspensions
#
#  id              :integer          not null, primary key
#  description     :string
#  suspension_date :date
#  suspension_type :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  farmer_id       :integer
#
# Indexes
#
#  index_farmer_suspensions_on_farmer_id  (farmer_id)
#
# Foreign Keys
#
#  fk_rails_...  (farmer_id => farmers.id)
#
class FarmerSuspension < ActiveRecord::Base
  has_many :farmer_suspension_reasons
  belongs_to :farmer
  
  before_create do
    if self.suspension_type == nil
      self.suspension_type = 'Suspensão'
    end
  end

  def create_sig_org_status(is_update = false)
    changes = []
    if self.suspension_type == "Suspensão"
      reasons = ""
      self.farmer_suspension_reasons.each do |reason|
          reasons << "* - #{reason.suspension_type.name} <br>"
      end
      reasons = "Nenhum motivo especificado." if reasons == "" #Se tiver vaziu, não informou motivos (Y)
      descricao = "Descrição: #{self.description}" if self.description.present?
      if is_update
        changes << ["Edição da ultima sespensão.  Novos motivos:" => "#{reasons} #{descricao}"]
      else
        changes << ["Agricultor suspenso.  Motivos:" => "#{ reasons} #{descricao}" ]
      end
    else
        changes << ["Suspensão removida" => "Remover suspensão no sig.org"]
    end
    farmer = Farmer.find(self.farmer_id)
    farmer.update_sig_org(changes)
  end
  def update_suspension_reasons(suspension_reasons)

    FarmerSuspensionReason.where(farmer_suspension_id: self.id).each do |farmer_suspension|
      farmer_suspension.destroy
    end
    if suspension_reasons != nil
      suspension_reasons.each do |suspension_type, value|

        FarmerSuspensionReason.create(farmer_suspension_id: self.id, suspension_type_id: suspension_type)
      end
    end
  end

end
