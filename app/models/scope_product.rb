# == Schema Information
#
# Table name: scope_products
#
#  id                        :integer          not null, primary key
#  amount                    :float
#  amount_per_year           :float
#  amount_per_year_unity     :string
#  area                      :float
#  is_processor              :boolean
#  package_size              :float
#  package_size_unity        :string
#  unity                     :string
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#  product_id                :integer
#  production_unity_scope_id :integer
#
# Indexes
#
#  index_scope_products_on_product_id                 (product_id)
#  index_scope_products_on_production_unity_scope_id  (production_unity_scope_id)
#
# Foreign Keys
#
#  fk_rails_...  (product_id => products.id)
#  fk_rails_...  (production_unity_scope_id => production_unity_scopes.id)
#
class ScopeProduct < ActiveRecord::Base
  belongs_to :product
  belongs_to :production_unity_scope
  validates_presence_of :product_id
  validates_uniqueness_of :product, scope: :production_unity_scope

  validate :product_in_scope

  UNITIES = { 'Quilograma' => 'Kg', 'Miligrama' => 'mg', 'Grama' => 'gr', 'Tonelada' => 'T', 'Mililitro' => 'ml', 'Litro' => 'L', 'Sacos' => 'sc', 'Unidade' => 'und', 'Molho' => 'mlh', 'Pacote' => 'pc', 'Duzia' => 'dz' }

  def self.UNITIES
    UNITIES.keys
  end

  def unity_value
    unity || amount_per_year_unity
  end

  def amount_value
    amount || amount_per_year
  end

  before_create do
    changes = []
    @production_scope = ProductionUnityScope.find(self.production_unity_scope_id)
    @product_name = Product.find(self.product_id).name

    if @production_scope.scope.scope_type == 1 #Se é um produto de unidade de produção
      amount_info = self.amount != nil ? "#{self.amount} #{self.unity}" : "Não informado"
      area_info = self.area != nil ? "#{self.area}" : "Não informado"
      changes << ["Novo produto: #{product.name} - Escopo: #{@production_scope.scope.name} - #{@production_scope.scope.acronym}"  => "Quantidade por ano: #{amount_info} - Área: #{area_info}"]
    else
      package_size_info = self.package_size != nil ? "#{self.package_size} #{self.package_size_unity}" : "Não informado"
      amount_per_year_info = self.package_size != nil ? "#{self.amount_per_year} #{self.amount_per_year_unity}" : "Não informado"
      is_processor_info = self.is_processor ? "Sim" : "Não"
      changes << ["Novo produto: #{product.name} - Escopo: #{@production_scope.scope.name} - #{@production_scope.scope.acronym}" => "Tamanho do embalagem: #{package_size_info} - Quantidade por ano: #{amount_per_year_info} - Contém ingredientes orgânicos: #{is_processor_info}"]
    end

    @production_scope.production_unity.update_sig_org(changes)
  end

  before_update do
    changes = []
    @production_scope = ProductionUnityScope.find(self.production_unity_scope_id)
    @product_name = Product.find(self.product_id).name
    amount_text = self.amount.present? ? "#{self.amount} #{self.unity}" : "Trocou para não informado."
    changes << ["Quantidade por ano de #{@product_name} - Escopo: #{@production_scope.scope.acronym}" => amount_text ] if (self.amount_changed? or self.unity_changed?)
    area_text = self.area.present? ? "#{self.area} ha" : "Trocou para não informado"
    changes << ["Area de #{@product_name} - Escopo: #{@production_scope.scope.acronym}" => area_text ] if self.area_changed?
    package_size_text = self.package_size.present? ? "#{self.package_size} #{self.package_size_unity}" : "Trocou para não informado"
    changes << ["Tamanho da embalagem de #{@product_name} - Escopo: #{@production_scope.scope.acronym}" => package_size_text] if (self.package_size_changed? or self.package_size_unity_changed?)
    amount_per_year_text = self.amount_per_year.present? ? "#{self.amount_per_year} #{self.amount_per_year_unity}" : "Mudou para não informado"
    changes << ["Quantidade por ano de #{@product_name} - Escopo: #{@production_scope.scope.acronym}" => amount_per_year_text] if (self.amount_per_year_changed? or self.amount_per_year_unity_changed?)
    is_processor_info = self.is_processor ? "Sim" : "Não"
    changes << ["#{@product_name} do escopo #{@production_scope.scope.acronym} contém produtos orgânicos" => is_processor_info] if self.is_processor_changed?
    @production_scope.production_unity.update_sig_org(changes)

  end

  before_destroy do
    changes = []
    @production_scope = ProductionUnityScope.find(self.production_unity_scope_id)
    @product_name = Product.find(self.product_id).name
    changes << ["Produto deletado: #{@product_name} - Escopo: #{@production_scope.scope.acronym}" => "Deletado."]

    @production_scope.production_unity.update_sig_org(changes) if @production_scope.production_unity
  end

  private

  def product_in_scope
    production_unity_scope = ProductionUnityScope.find(self.production_unity_scope)
    the_product = Product.find(self.product_id)
    category = ProductCategory.find(the_product.product_category.id)
    if not category.products.find(the_product.id).present?
      errors.add(:product_id, "Não é possível adicionar este produto.")
    end
  end

end
