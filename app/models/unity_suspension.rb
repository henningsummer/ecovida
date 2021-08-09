# == Schema Information
#
# Table name: unity_suspensions
#
#  id                  :integer          not null, primary key
#  description         :string
#  suspension_date     :date
#  suspension_type     :string
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  production_unity_id :integer
#
# Indexes
#
#  index_unity_suspensions_on_production_unity_id  (production_unity_id)
#
# Foreign Keys
#
#  fk_rails_...  (production_unity_id => production_unities.id)
#
class UnitySuspension < ActiveRecord::Base
  belongs_to :production_unity
  has_many :unity_suspension_reasons
  
  before_create do
    if self.suspension_type == nil
      self.suspension_type = 'Suspensão'
    end
  end

 def create_sig_org_status(is_update = false)
    changes = []
    if self.suspension_type == "Suspensão"
      reasons = ""
      self.unity_suspension_reasons.each do |reason|
          reasons << "* - #{reason.unity_suspension_type.name} <br>"
      end
      reasons = "Nenhum motivo especificado." if reasons == "" #Se tiver vaziu, não informou motivos (Y)
      descricao = "Descrição: #{self.description}" if self.description.present?
      if is_update
        changes << ["Edição da ultima sespensão.  Novos motivos:" => "#{reasons} #{descricao}"]
      else
        changes << ["suspenso.  Motivos:" => "#{ reasons} #{descricao}" ]
      end
    else
        changes << ["Suspensão removida" => "Remover suspensão no sig.org"]
    end
    production_unity = ProductionUnity.find(self.production_unity_id)
    production_unity.update_sig_org(changes)
  end


  def update_suspension_reasons(suspension_reasons)

    UnitySuspensionReason.where(unity_suspension_id: self.id).each do |unity_suspension|
      unity_suspension.destroy
    end
    if suspension_reasons != nil
      suspension_reasons.each do |suspension_type, value|
        UnitySuspensionReason.create(unity_suspension_id: self.id, unity_suspension_type_id: suspension_type)
      end
    end
  end

end
