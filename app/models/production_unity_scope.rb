# == Schema Information
#
# Table name: production_unity_scopes
#
#  id                      :integer          not null, primary key
#  bushland_area           :float
#  organic_production_area :float
#  total_area              :float
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  production_unity_id     :integer
#  scope_id                :integer
#
# Indexes
#
#  index_production_unity_scopes_on_production_unity_id  (production_unity_id)
#  index_production_unity_scopes_on_scope_id             (scope_id)
#
# Foreign Keys
#
#  fk_rails_...  (production_unity_id => production_unities.id)
#  fk_rails_...  (scope_id => scopes.id)
#
class ProductionUnityScope < ActiveRecord::Base
  belongs_to :scope
  belongs_to :production_unity
  has_many :scope_products, dependent: :destroy

  validates_presence_of :production_unity_id, :scope_id
  validates_uniqueness_of :scope_id, scope: :production_unity_id

  validate :authencity


  private

  before_update do
    changes = []
    area_text = self.total_area.present? ? "#{self.total_area} ha" : "Mudou para não informado"
    changes << ["Mudou a área total do escopo #{self.scope.name} - #{self.scope.acronym}" => area_text] if self.total_area_changed?
    production_unity.update_sig_org(changes)
  end

  def authencity
    @production_unity = ProductionUnity.find(self.production_unity_id)
    @scope = Scope.find(self.scope_id)
    if @scope.scope_type != @production_unity.scope_type
      @errors.add(:scope_id, 'Impossível cadastrar este escopo nesta unidade de produção')
    end
  end
end
