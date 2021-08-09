# == Schema Information
#
# Table name: production_unities
#
#  id                  :integer          not null, primary key
#  address             :string
#  cep                 :string
#  email               :string
#  excluded            :boolean
#  excluded_with_group :boolean          default(FALSE)
#  fantasy_name        :string
#  lat_hour            :integer
#  lat_minute          :integer
#  lat_second          :decimal(, )
#  lat_type            :string
#  lon_hour            :integer
#  lon_minute          :integer
#  lon_second          :decimal(, )
#  lon_type            :string
#  name                :string
#  neighborhood        :string
#  number              :string
#  number_type         :integer
#  phone               :string
#  production_type     :string
#  register_number     :string
#  register_type       :string
#  scope_type          :integer
#  total_area          :string
#  total_native_area   :string
#  total_organic_area  :string
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  city_id             :integer
#  group_id            :integer
#
# Indexes
#
#  index_production_unities_on_city_id   (city_id)
#  index_production_unities_on_group_id  (group_id)
#
# Foreign Keys
#
#  fk_rails_...  (city_id => cities.id)
#  fk_rails_...  (group_id => groups.id)
#
class ProductionUnity < ActiveRecord::Base
  belongs_to :city
  belongs_to :group
  has_many :certificate_names
  has_many :production_unity_farmers
  has_many :farmers, through: :farmers
  has_many :production_unity_scopes
  has_many :scope_products, through: :production_unity_scopes
  has_many :unity_suspensions
  has_many :sigorgs

  validates_format_of :cep, with: /[0-9]{8}/, message: "Use apenas números. Exemplo: 95560000"
  validates_inclusion_of :number_type, :in => [1, 2], :if => :is_agribusiness?
  validates_presence_of :number, :number_type, :if => :is_agribusiness?
  validates_presence_of :name, :address, :neighborhood, :city_id, :group_id, :scope_type, :cep
  validate :validate_number, :if => :is_agribusiness?
  validates_inclusion_of :production_type, :in => ProductionUnityForm.SCOPE_TYPES
  validates_presence_of :total_area, :total_organic_area, :if => :is_production_unity?
  validates_numericality_of :total_area, :total_organic_area, :if => :is_production_unity?
  # validates_uniqueness_of :number, conditions: -> { where(excluded: false, scope_type: 2, number_type: 1).where.not(number: nil) } # Onde é CPF e nao tem number
  validates :lat_hour, :lat_minute, :lat_second, :lat_type, presence: true, if: :is_production_unity?
  validates :lon_hour, :lon_minute, :lon_second, :lon_type, presence: true, if: :is_production_unity?
  validates_numericality_of :lat_hour, greater_than_or_equal_to: 0, less_than_or_equal_to: 90, if: :is_production_unity?
  validates_numericality_of :lon_hour, greater_than_or_equal_to: 0, less_than_or_equal_to: 180, if: :is_production_unity?
  validates_numericality_of :lat_second, :lon_second, greater_than_or_equal_to: 0, less_than_or_equal_to: 60.99, if: :is_production_unity?
  validates_numericality_of :lon_minute, :lat_minute, greater_than_or_equal_to: 0, less_than_or_equal_to: 60, if: :is_production_unity?
  validates_inclusion_of :lon_type, :in => ["L", "O"], :if => :is_production_unity?
  validates_inclusion_of :lat_type, :in => ["N", "S"], :if => :is_production_unity?
  default_scope { where(excluded: false) }
  
  scope :state_id_eq, lambda { |state_id| joins(city: :state).where(states: { id: state_id })}
  scope :core_id_eq, lambda { |core_id| joins(group: :core).where(cores: { id: core_id }) }
  scope :product_id_eq, ->(*product_id) do
    product_id.shift
    flatten_id = product_id.flatten
    joins(scope_products: :product).where(products: { id: flatten_id })
    .having("count(production_unities.id) >= #{flatten_id.count}")
    .group('production_unities.id')
  end
  
  def self.ransackable_scopes(auth_object = nil)
    %i(state_id_eq core_id_eq product_id_eq)
  end
  
  def all_scope_products
    scope_products
  end
  
  def full_address
    "#{[address, neighborhood].delete_if{|x| x == ''}.compact.join(', ')} - #{city.name}"
  end
  
  def dac_date
    if responsible.dac_date
      responsible.dac_date
    else
      production_unity_farmers.each do |pu|
        if pu.farmer.dac_date
          return pu.farmer.dac_date
        end
      end
      false
    end
  end
  
  def agribusiness_farmers_thar_can_receive_certificate(agribusiness_documents = nil, farmer_documents = nil, production_unity_documents = nil)
    farmer_documents           ||= Document.where(subject: 'farmer', required_for_certificate: 'yes_answer', status: 'active')
    agribusiness_documents     ||= Document.where(subject: 'agribusiness', required_for_certificate: 'yes_answer', status: 'active')
    production_unity_documents ||= Document.where(subject: 'production_unity', required_for_certificate: 'yes_answer', status: 'active')
    
    analysis = Certification.verify_agribusiness(self, agribusiness_documents, farmer_documents, production_unity_documents)
    
    analysis.farmers.select { |fa| fa.can_generate_agribusiness }.map(&:subject)
  end
  
  def can_have_certificate?
    document_analysis.can_receive_certificate
  end
  
  def document_analysis
    production_unity_documents = Document.where(subject: 'production_unity', required_for_certificate: 'yes_answer', status: 'active')
    
    if is_agribusiness?
      farmer_documents           = Document.where(subject: 'farmer', required_for_certificate: 'yes_answer', status: 'active')
      agribusiness_documents     = Document.where(subject: 'agribusiness', required_for_certificate: 'yes_answer', status: 'active')
      
      Certification.verify_agribusiness(self, agribusiness_documents, farmer_documents, production_unity_documents)
    else
      production_unity_documents = Document.where(subject: 'production_unity', required_for_certificate: 'yes_answer', status: 'active')
      
      Certification.verify_production_unity(self, production_unity_documents)
    end
  end
  
  def products
    # Retorna os produtos
    products = []
    production_unity_scopes.each do |pus|
      pus.scope_products.each do |sp|
        products << sp
      end
    end
    products
  end

  def is_production_unity?
    self.scope_type == 1
  end
  
  def is_agribusiness?
    self.scope_type == 2
  end
  
  def farmers
    self.group.farmers.where(id: production_unity_farmers.map{|puf| puf.farmer_id})
  end
  
  def self.text_search(query)
    where(["name ILIKE :query or cep ILIKE :query or address ILIKE :query or neighborhood ILIKE :query or fantasy_name ILIKE :query or number ILIKE :query or register_number ILIKE :query or phone ILIKE :query or email ILIKE :query" , query: "%#{query}%"])
  end
  
  before_validation do
    if cpf?
      cpf_class = CPF.new(number)
      self.number = cpf_class.stripped if cpf_class.valid?
    elsif cnpj?
      cnpj_class = CNPJ.new(number)
      self.number = cnpj_class.stripped if cnpj_class.valid?
    end
  end
  
  def cpf?
    number_type == 1
  end
  
  def cnpj?
    number_type == 2
  end
  
  def validate_number
    require 'cpf_cnpj'
    
    if self.number_type == 1
      errors.add(:number, 'CPF é inválido') unless CPF.valid? self.number
    else
      errors.add(:number, 'CNPJ é inválido') unless CNPJ.valid? self.number
    end
  end
  
  def sig_org_changes
    if sigorgs.count > 0
      if sigorgs.last.sig_org_type == Sigorg.OUTDATED
        sigorgs.last.column_changes
      else
        'atualizado'
      end
    else
      nil #Não foi atualizado
    end
  end
  
  def sig_org_status
    if sigorgs.count > 0
      if sigorgs.last.sig_org_type == Sigorg.OUTDATED
        'Desatualizado'
      else
        'Atualizado'
      end
    else
      'Não adicionado'
    end
  end
  
  def set_sig_org_updated
    if self.sig_org_status != 'Atualizado'
      self.sigorgs.build(sig_org_type: Sigorg.UPDATED).save
      true
    else
      false
    end
  end
  
  
  
  def update_sig_org(changes)
    if changes.count != 0
      if self.sigorgs.count != 0
        if self.sigorgs.last.sig_org_type == Sigorg.UPDATED
          @sig_org = self.sigorgs.build(sig_org_type: Sigorg.OUTDATED)
          if @sig_org.save
            @sig_org.update_changes(changes)
          end
        else
          self.sigorgs.last.update_changes(changes)
        end
      end
    end
  end
  
  
  def is_suspended?
    if unity_suspensions.count != 0
      unity_suspensions.last.suspension_type == 'Suspensão' ? true : false
    else
      false
    end
  end
  
  def suspended_name
    if is_suspended?
      "#{name} (Suspenso)"
    else
      name
    end
  end
  
  def responsible
    production_unity_farmers.where(is_responsible: true)&.first&.farmer
  end
  
  
  before_update do
    changes = []
    changes << ["nome" => self.name] if self.name_changed?
    changes << ["tipo" => self.production_type] if self.production_type_changed?
    changes << ["endereço" => "#{self.address}, #{self.neighborhood}, #{self.city.name} - #{self.city.state.uf}, #{self.cep}"] if self.address_changed? or self.neighborhood_changed? or self.city_id_changed? or self.cep_changed?
    changes << ["Área total" => self.total_area] if self.total_area_changed?
    changes << ["Área total orgânica" => self.total_organic_area] if self.total_organic_area_changed?
    changes << ["Total da área nativa" => self.total_native_area] if self.total_native_area_changed?
    changes << ["Nome fantasia" => self.fantasy_name] if self.fantasy_name_changed?
    changes << ["Tipo de numero" => "Agora é #{self.number_type == 1 ? "CPF" : "CNPJ"}"] if self.number_type_changed?
    changes << ["Novo numero" => self.number] if self.number_changed?
    changes << ["Tipo de registro" => self.register_type] if self.register_type_changed?
    changes << ["Numero de registro" => self.register_number] if self.register_number_changed?
    changes << ["Telefone" => self.phone] if self.phone_changed?
    changes << ["Email" => self.email] if self.email_changed?
    coordinate_text = self.lat_hour.present? ? "Latitude: #{self.lat_hour}º #{self.lat_minute}' #{self.lat_second}'' #{self.lat_type}.  Longitude: #{self.lon_hour}º #{self.lon_minute}' #{self.lon_second}'' #{self.lon_type}" : "Mudou para não informado."
    changes << ["Coordenadas geográficas" => coordinate_text] if self.lat_hour_changed? or self.lat_minute_changed? or self.lat_second_changed? or self.lat_type_changed? or self.lon_hour_changed? or self.lon_minute_changed? or self.lon_second_changed? or self.lon_type_changed?
    
    update_sig_org(changes)
  end
  
  def group_unscoped
    Group.unscoped.find(group_id)
  end
  
  def scope_name
    return 'Unidade de produção' if scope_type == 1
    return 'Agroindústria' if scope_type == 2
  end
end
