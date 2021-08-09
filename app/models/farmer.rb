# == Schema Information
#
# Table name: farmers
#
#  id                   :integer          not null, primary key
#  address              :string
#  birthday             :date
#  cell_phone           :string
#  contract_of_adhesion :boolean          default(FALSE)
#  em_ata               :boolean
#  email                :string
#  excluded             :boolean
#  excluded_with_group  :boolean          default(FALSE)
#  farmer_code          :string
#  gender               :string
#  lembrete             :text
#  name                 :string
#  neighborhood         :string
#  number               :string
#  number_type          :integer
#  phone_number         :string
#  rg                   :string
#  spouse               :string
#  spouse_birthday      :date
#  spouse_cpf           :string
#  spouse_gender        :string
#  suspended            :boolean
#  termo_compromisso    :boolean
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  city_id              :integer
#  group_id             :integer
#
# Indexes
#
#  index_farmers_on_city_id   (city_id)
#  index_farmers_on_group_id  (group_id)
#
# Foreign Keys
#
#  fk_rails_...  (city_id => cities.id)
#  fk_rails_...  (group_id => groups.id)
#
class Farmer < ActiveRecord::Base
  belongs_to :city
  belongs_to :group

  has_many :farmer_group_changes
  has_many :farmer_families
  has_many :set_suplentes
  has_many :production_unity_farmers
  has_many :production_unities, through: :production_unity_farmers
  has_many :scope_products, through: :production_unities
  has_many :dacs
  has_many :daps
  has_many :farmer_suspensions
  has_many :sigorgs
  has_many :certificate_names

  validate :conjuge
  validate :validate_number

  validates :name, presence: true
  validates :address, presence: true
  validates :neighborhood, presence: true
  validates :group_id, presence: true
  validates :city_id, presence: true
  validates :number_type, presence: true
  validates_uniqueness_of :number, conditions: -> { where(excluded: false) }
  validates_uniqueness_of :spouse_cpf, conditions: -> { where(excluded: false) }, if: :spouse_cpf_present
  has_enumeration_for :gender, with: Genders
  has_enumeration_for :spouse_gender, with: Genders

  scope :name_exists, ->(name) { where(["name ILIKE :name", name: "%#{name}%"]) }

  validates_presence_of :spouse_gender, :spouse_birthday, if: :has_spouse?, on: :create

  validates_date :birthday, before: Date.today, before_message: 'deve ser em uma data no passado', on: :create, if: :birthday
  validates_date :spouse_birthday, before: Date.today, before_message: 'deve ser em uma data no passado', on: :create, if: :spouse_birthday

  default_scope { where(excluded: false) }

  before_validation do
    if cpf?
      cpf_class = CPF.new(number)
      self.number = cpf_class.stripped if cpf_class.valid?
    elsif cnpj?
      cnpj_class = CNPJ.new(number)
      self.number = cnpj_class.stripped if cnpj_class.valid?
    end
  end

  def spouse_cpf_present
    spouse_cpf.present?
  end

  def cpf?
    number_type == 1
  end

  def all_scope_products
    production_unities.map(&:scope_products).flatten
  end

  def cnpj?
    number_type == 2
  end

  def self.get_farmers_from_group(group)
    all.where(group: group).order(:name).collect{|c| [c.name, c.id]}
  end

  def self.text_search(query)
    where(["farmers.name ILIKE :query or farmers.farmer_code ILIKE :query or farmers.number ILIKE :query or farmers.address ILIKE :query or farmers.neighborhood ILIKE :query or farmers.phone_number ILIKE :query or farmers.cell_phone ILIKE :query or farmers.email ILIKE :query or farmers.spouse ILIKE :query or farmers.spouse_cpf ILIKE :query or farmers.lembrete ILIKE :query" , query: "%#{query}%"])
  end

  def self.count_by_year(year)
    start_date = Date.new(y=year)
    end_date = start_date + 1.year
    Farmer.where("created_at >= '#{start_date}' and created_at < '#{end_date}'").count
  end

  def production_unities
    production_unities = []
    production_unity_farmers.each do |pu|
      production_unities << pu.production_unity if pu.production_unity.scope_type == 1
    end
    production_unities
  end

  def certificable_production_unities(farmer_documents = nil, production_unity_documents = nil)
    farmer_documents           ||= Document.where(subject: 'farmer', required_for_certificate: 'yes_answer', status: 'active')
    production_unity_documents ||= Document.where(subject: 'production_unity', required_for_certificate: 'yes_answer', status: 'active')

    analysis = Certification.verify_farmer(self, farmer_documents, production_unity_documents)

    analysis.production_unities.select { |pu| pu.can_receive_certificate }.map(&:subject)
  end

  def production_unity_products
    # Retorna os produtos das unidades de produções não suspensas.
    products = []
    certificable_production_unities.each do |pu|
      pu.products.each do |product|
        products << product.product unless products.include? product.product
      end
    end
    products
  end

  def production_unity_scope_products
    # Retorna os scope_produtos das unidades de produções não suspensas.
    products = []
    certificable_production_unities.each do |pu|
      pu.products.each do |product|
        products << product unless products.include? product
      end
    end
    products
  end

  def generate_certificate_products(certificate)
    production_unity_products.each do |product|
      certificate.certificate_products.create(
        name: product.name,
        product_id: product.id,
        contain_organic: false
      )
    end
  end

  def agribusiness
    production_unities = []
    production_unity_farmers.each do |pu|
      production_unities << pu.production_unity if pu.production_unity.scope_type == 2
    end
    production_unities
  end

  def set_sig_org_updated
    if self.sig_org_status != 'Atualizado'
      self.sigorgs.build(sig_org_type: Sigorg.UPDATED).save
      true
    else
      false
    end
  end

  before_create do
    group = Group.find(self.group_id)
    uf = group.core.state.uf
    self.farmer_code = generate_code(uf, group.core.next_farmer_count + 1, group.core.number_from_state)
    group.core.update(next_farmer_count: group.core.next_farmer_count + 1)
  end

  before_update do

    #Pega o que mudou e bota em um array.  Verificar se já está desatualizado
    #Se sim, atualiza o existne, se não, cria um novo sigorg do tipo desatualizado
    #Se não existe sigorg, não faz nada.

    #O que vai pro sigorg
    changes = []
    changes << ["nome" => self.name] if name_changed?
    changes << ["CPF ou CNPJ" => self.number] if number_changed?
    changes << ["Cidade" => self.city.name] if self.city_id_changed?
    changes << ["Bairro" => self.neighborhood] if self.neighborhood_changed?
    changes << ["Email" => self.email] if self.email_changed?
    changes << ["Telefone" => self.phone_number] if self.phone_number_changed?
    changes << ["Celular" => self.cell_phone] if self.cell_phone_changed?
    changes << ["Endereço" => self.address] if self.address_changed?
    changes << ["nome do conjuge" => self.spouse] if self.spouse_changed?
    changes << ["CPF do conjuge" => self.spouse_cpf] if self.spouse_cpf_changed?

    update_sig_org(changes)

  end

  def can_receive_group_change
    can = true
    production_unity_farmers.each do |puf|
      can = false if puf.production_unity.production_unity_farmers.count != 1
    end
    return can
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

  def sig_org_changes
    if sigorgs.count > 0
      if sigorgs.last.sig_org_type == Sigorg.OUTDATED
        sigorgs.last.column_changes #O que foi mudado
      else
        'atualizado' #Não tem changes, tá atualizado
      end
    else
      nil #Não foi adicionado
    end
  end

  def sig_org_status
    if sigorgs.count > 0
      if sigorgs.last.sig_org_type == Sigorg.OUTDATED
        'Desatualizado' #O que foi mudado
      else
        'Atualizado' #Não tem changes, tá atualizado
      end
    else
      'Não adicionado' #Não foi adicionado
    end
  end

  # Nunca foi utilizado
  # def self.FARMER_TYPES
  #   return FARMER_TYPES
  # end

  def dac_due_date
    if dacs.present?
      dacs.order(dac_date: :desc).first.dac_date + 365 #Ultima D.A.C
    else
      false
    end
  end

  def dac_valid?
    return false unless dacs.present?

    dac_due_date > Time.now() + 365
  end

  def dac_date
    if dacs.present?
      dacs.order(dac_date: :desc).first.dac_date
    else
      false
    end
  end

  def is_suspended?
    if farmer_suspensions.count != 0
      farmer_suspensions.last.suspension_type == 'Suspensão' ? true : false
    else
      false
    end
  end

  def remove_suspension!
    if is_suspended?
      FarmerSuspension.create(farmer_id: self.id, suspension_type: 'Remoção da suspensão', suspension_date: Date.today)
      true
    else
      false
    end
  end

  def dap_due_date
    if daps.present?
      daps.order(validity: :desc).first.validity #Ultima D.A.C
    else
      false
    end
  end

  def documents_ok?(dap = true)
    farmer_documents           = Document.where(subject: 'farmer', required_for_certificate: 'yes_answer', status: 'active')
    production_unity_documents = Document.where(subject: 'production_unity', required_for_certificate: 'yes_answer', status: 'active')

    can = Certification.verify_farmer(self, farmer_documents, production_unity_documents).can_generate_agribusiness

    if dap
      is_ok = true

      if self.dap_due_date != false
        is_ok = false if self.dap_due_date < Time.now()
      else
        is_ok = false
      end

      return can && is_ok
    end

    can
  end

  def can_have_certificate?
    farmer_document_analysis.can_receive_certificate
  end

  def farmer_document_analysis
    farmer_documents           = Document.where(subject: 'farmer', required_for_certificate: 'yes_answer', status: 'active')
    production_unity_documents = Document.where(subject: 'production_unity', required_for_certificate: 'yes_answer', status: 'active')

    analysis = Certification.verify_farmer(self, farmer_documents, production_unity_documents)
  end

  def self.get_farmers(from_group = false)
    #Retorna todos os agricultores pra view, pode ser de um grupo só ou não.
    if from_group.nil?
      all.collect{|farmer| [farmer.name, farmer.id]}
    else
      from_group.farmers.collect{|farmer| [farmer.name, farmer.id]}
    end
  end

  def group_unscoped
    Group.unscoped.find(group_id)
  end

  def has_spouse?
    spouse.present?
  end

  def spouse_cpf=(cpf)
    super(CPF.new(cpf).stripped)
  end

  private

  def conjuge
    if self.spouse.present?
      require 'cpf_cnpj'
      errors.add(:spouse_cpf, 'CPF está inválido') unless CPF.valid? self.spouse_cpf
      errors.add(:spouse_cpf, 'CPF já em uso') if Farmer.where(spouse_cpf: self.spouse_cpf).count > 1
    end
  end

  def validate_number
    require 'cpf_cnpj'
    if number_type == 1
      errors.add(:number, 'CPF é inválido') unless CPF.valid? self.number
    else
      errors.add(:number, 'CNPJ é inválido') unless CNPJ.valid? self.number
    end
  end

  def generate_code(state, farmer_id, core_id)
    #Gera o código para o agricultor, exemplo: RS01002 onde 001 é o núcleo
    #e o 002 o agricultor. (Quatnidade de agricultor no grupo)
    code = state

    if core_id < 10
      code << '0'
      code << core_id.to_s
    else
      code << core_id.to_s
    end

    if farmer_id < 10
      code << '00'
      code << farmer_id.to_s
    elsif farmer_id >= 10 and farmer_id < 100
      code << '0'
      code << farmer_id.to_s
    else
      code << farmer_id.to_s
    end

    return code

  end



end
