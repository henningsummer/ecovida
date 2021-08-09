# == Schema Information
#
# Table name: production_unity_farmers
#
#  id                  :integer          not null, primary key
#  is_responsible      :boolean
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  farmer_id           :integer
#  production_unity_id :integer
#
# Indexes
#
#  index_production_unity_farmers_on_farmer_id            (farmer_id)
#  index_production_unity_farmers_on_production_unity_id  (production_unity_id)
#
# Foreign Keys
#
#  fk_rails_...  (farmer_id => farmers.id)
#  fk_rails_...  (production_unity_id => production_unities.id)
#
class ProductionUnityFarmer < ActiveRecord::Base
  belongs_to :farmer
  belongs_to :production_unity

  validate :only_one_responsible

  validates_uniqueness_of :farmer_id, scope: :production_unity_id

  validates_presence_of :farmer_id, :production_unity_id

  default_scope { joins(:production_unity).where('production_unities.excluded = false')
                 .joins(:farmer).where('farmers.excluded = false')}

  before_destroy do
    farmer = Farmer.find(self.farmer_id)
    changes = []
    changes << ["Agricultor desvinculado" => farmer.name]

    production_unity = ProductionUnity.find(self.production_unity_id)

    production_unity.update_sig_org(changes)

  end

  before_create do
    farmer = Farmer.find(self.farmer_id)
    changes = []
    changes << ["Agricultor vinculado" => farmer.name]

    production_unity = ProductionUnity.find(self.production_unity_id)

    production_unity.update_sig_org(changes)

  end

  def turn_responsible
    if not self.is_responsible
      production_unity_farmer = ProductionUnityFarmer.where(production_unity_id: self.production_unity_id, is_responsible: true).first
      production_unity_farmer.is_responsible = false
      production_unity_farmer.save
      self.is_responsible = true
      self.save

      farmer = Farmer.find(self.farmer_id)

      changes = []
      changes << ["Tem um novo responsável." => farmer.name]



      production_unity = ProductionUnity.find(self.production_unity_id)


      production_unity.update_sig_org(changes)

      true
    else
      nil
    end
  end

  private

  def only_one_responsible
    # Nunca é pra chegar aqui, mas para garantir, não vamos deixar cadastrar dois responsáveis
    if ProductionUnityFarmer.where(production_unity_id: self.production_unity_id, is_responsible: true).count > 0 and self.is_responsible == true
      errors.add(:farmer_id, "Já há um agricultor responsável")
    end
  end

end
