# == Schema Information
#
# Table name: cores
#
#  id                   :integer          not null, primary key
#  coordinator_email    :string
#  coordinator_name     :string
#  coordinator_phone    :string
#  email                :string
#  inactive_certificate :boolean          default(FALSE)
#  login                :string
#  name                 :string
#  next_farmer_count    :integer          default(0)
#  number_from_state    :integer
#  password_digest      :string
#  phone                :string
#  sig_org_access       :boolean
#  total_power          :boolean
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  state_id             :integer
#
# Indexes
#
#  index_cores_on_state_id  (state_id)
#
# Foreign Keys
#
#  fk_rails_...  (state_id => states.id)
#
class Core < ActiveRecord::Base
  has_secure_password
  has_many :groups
  has_many :core_coordinators
  belongs_to :state
  has_many :farmers, through: :groups
  has_many :core_payments

  validates_presence_of :login, :name, :state_id, :email, :phone
  validates_uniqueness_of :login, :name, scope: :login
  #validates_format_of :login, with: /^[a-z0-9]{3,16}$/, multiline: true, message:  'é inválido, por favor, utilize letras de a-z, numeros 1-9 e não use espaços ou caracteres especiais'
  validate :validar_login

  scope :order_by_name, -> { order(name: :asc) }

  before_create do
    state = State.find(self.state_id)
    self.number_from_state = state.cores.count + 1
  end

  def coordinator
    core_coordinators.find_by(current: true)
  end

  def summarizing(year)
    productive, unproductive = summarized_farmers(year.to_i)
    productive_amount = productive * SystemSetting.basic_rate
    unproductive_amount = unproductive * SystemSetting.propertyless_rate
    agribusiness_amount = summarized_agribusiness(year.to_i) * SystemSetting.agribusiness_rate
    amount = productive_amount + unproductive_amount + agribusiness_amount
    {
      amount: amount,
      productive: productive,
      unproductive: unproductive,
      agribusiness: summarized_agribusiness(year.to_i)
    }
  end

  def summarized_agribusiness(year)
    array = []

    production_unities.each do |production_unity|
      array << production_unity if production_unity.created_at.year <= year && production_unity.scope_type == 2 && !production_unity.is_suspended?
    end

    array.count
  end

  def summarized_farmers(year)
    productive = []
    unproductive = []

    farmers.each do |farmer|
      if farmer.created_at.year <= year
        if farmer.production_unities.count == 0
          if farmer.agribusiness.count == 0
            unproductive << farmer unless farmer.is_suspended?
          end
        else
          productive << farmer unless farmer.is_suspended?
        end
      end
    end
    [ productive.count, unproductive.count ]
  end

  def production_unities
    pu = []
    self.groups.each do |group|
      group.production_unities.each do |production_unity|
        pu << production_unity
      end
    end
    ProductionUnity.where(id: pu.map{|production_unity| production_unity.id})
  end

  def farmer_count
    Farmer.unscoped {
      farmer_count = 0
      self.groups.each do |group|
        farmer_count = farmer_count + group.farmers.count
      end
      farmer_count
    }
  end

  def active_farmer_count
    farmer_count = 0
    self.groups.each do |group|
      farmer_count = farmer_count + group.farmers.count
    end
    farmer_count
  end

  def self.search(query, state_id)
    if query.present? or state_id.present?
      query = where(["name ILIKE :query or login ILIKE :query", query: "%#{query}%"])
      query = query.where(state_id: state_id) if state_id.present?
      query
    else
      all
    end
  end


  def group_count
    self.groups.count
  end

  def self.authenticate(login, password)
    core = Core.find_by(login: login).try(:authenticate, password)
  end

  def validar_login
    if(Admin.find_by(login: self.login) or Group.find_by(login: self.login))
      errors.add(:login, "Já está sendo utilizado")
    end
  end
end
