# == Schema Information
#
# Table name: groups
#
#  id              :integer          not null, primary key
#  email           :string
#  excluded        :boolean          default(FALSE)
#  login           :string           not null
#  name            :string           not null
#  password_digest :string
#  phone           :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  core_id         :integer
#  group_type_id   :integer
#  suplente_id     :integer
#  titular_id      :integer
#
# Indexes
#
#  index_groups_on_core_id        (core_id)
#  index_groups_on_group_type_id  (group_type_id)
#
# Foreign Keys
#
#  fk_rails_...  (core_id => cores.id)
#  fk_rails_...  (group_type_id => group_types.id)
#
class Group < ActiveRecord::Base

  attr_accessor :user_and_type_of_logged_user #Para o log
  belongs_to :core
  belongs_to :group_type

  has_many :certificate_groups
  has_many :production_unities
  has_many :scope_products, through: :production_unities
  has_many :products, through: :scope_products
  has_many :set_suplentes
  has_many :farmers
  belongs_to :suplente, class_name: "Farmer", foreign_key: 'suplente_id'
  belongs_to :titular, class_name: "Farmer", foreign_key: 'titular_id'
  has_many :dac_documents

  has_secure_password
  validates :name, :login, :core_id, :group_type_id, presence: true
  validates_uniqueness_of :login, :name
  #validates_format_of :login, with: /^[a-z0-9_-]{3,16}$/, multiline: true, message:  'é inválido, por favor, utilize letras de a-z, numeros 1-9 e não use espaços ou caracteres especiais'

  default_scope { where(excluded: false) }
  scope :order_by_name, -> { order(name: :asc) }

  def dac_expiration_date
    return false unless dac_documents.any?
  end

   def self.authenticate(login, password)
     Group.find_by(login: login).try(:authenticate, password)
	 end

   def scopes
     Reports::ProductsReport.generate_products_to_report(self)
   end

   def core_name
     core.name
   end

   def is_updated
      # Retorna se o grupo está atualizado no SigOrg ou não.
      (outdateds.count == 0 and not_added_in_sigorg.count == 0) ? true : false
   end

   def self.text_search(query)
    where(["groups.name ILIKE :query or groups.login ILIKE :query or groups.phone ILIKE :query or groups.email ILIKE :query", query: "%#{query}%"])
   end

   def expirated_dac?
    return true unless dac_documents.any?
    return true unless dac_documents.last.dac_date

    (dac_documents.last.dac_date + 1.year) < Time.now.utc
   end

   def self.search(query, state, not_updated, user_type, current_user)
     if query.present? or state.present? or not_updated != "0"
      q = where(["groups.name ILIKE :query", query: "%#{query}%"])
      q = q.joins(:core).where(["cores.state_id = :state", state: state]) if state.present?

      can = true #Para sig_org

      if user_type.in? 2..3 and not_updated != "0"
        if Core.find(current_user).sig_org_access == true
          q = q.where(core_id: current_user)
          can = true
        else
          can = false
        end
      end

      #Busca os desatualizados se puder.
      if not_updated != "0" and can
        new_q = []
        q.each do |group|
          new_q << group unless group.is_updated
        end

      end

      if new_q.kind_of?(Array)
        q = q.where(id: new_q.map{|group| group.id}) #Busca todos do new q e transforma em um active record relation
      end
      return q

     else
      all
     end
   end

   def farmers_suspended
    farmer_array = []
    farmers.each do |farmer|
      farmer_array << farmer if farmer.is_suspended?
    end
    Farmer.where(id: farmer_array.map{|farmer| farmer.id})
   end


   ## farmers_that_can_have_a_certificade
   # Retorna os farmer que podem receber certificado.

   def farmers_that_can_have_a_certificade
    farmer_array = []
    farmers.each do |farmer|
      farmer_array << farmer if farmer.can_have_certificate?
    end
    Farmer.where(id: farmer_array.map{|farmer| farmer.id})
   end

   def outdateds
     outdateds = []

     farmers.each do |farmer|
       outdateds << farmer if farmer.sig_org_status == 'Desatualizado'
     end

     production_unities.each do |production_unity|
       outdateds << production_unity if production_unity.sig_org_status == 'Desatualizado'
     end

     return outdateds
   end

   ## farmer_that_have_production_unities_to_certificate
   # Retorna os farmers que possuem production unities não suspensa e com produtos
   def farmer_that_have_production_unities_to_certificate
     farmers_array = []
     farmers_that_can_have_a_certificade.each do |farmer|
       farmer.production_unities.each do |pu|
         farmers_array << farmer if (!(pu.is_suspended?) &&
                                     !(pu.products.count == 0) &&
                                     !(farmers_array.include?(farmer))) &&
                                     !(pu.production_type == 'Em transição')
       end
     end
     farmers_array
   end

   def agribusiness_that_can_have_a_certificate
    #Retorna todas agro-industrias que podem receber certificado.
    agribusiness_array = []
    farmers_that_can_have_a_certificade.each do |farmer|
      if farmer.agribusiness.count != 0
        farmer.agribusiness.each do |agribusiness|
          agribusiness_array << agribusiness if !(agribusiness_array.include? agribusiness) &&
                                                !(agribusiness.is_suspended?) &&
                                                !(agribusiness.products.count == 0)
        end
      end
    end
    agribusiness_array
   end


   def not_added_in_sigorg
     not_added = []

     farmers.each do |farmer|
       not_added << farmer if farmer.sig_org_status == 'Não adicionado'
     end

     production_unities.each do |production_unity|
       not_added << production_unity if production_unity.sig_org_status == 'Não adicionado'
     end

     return not_added
   end

   def update_outdateds(farmers_to_update, production_unities_to_update)
     if farmers_to_update.count > 0
       farmers_to_update.each do |id, ok|
         farmer = self.farmers.where(id: id).first
         farmer.sigorgs.build(sig_org_type: Sigorg.UPDATED).save
         SystemLog.create(description: "Atualizou #{farmer.name} (#{farmer.farmer_code}) no sig Org (Via Atualização em massa)", author: self.user_and_type_of_logged_user)
       end
     end
     if production_unities_to_update.count > 0
       production_unities_to_update.each do |id, ok|
         production_unity = self.production_unities.where(id: id).first
         production_unity.sigorgs.build(sig_org_type: Sigorg.UPDATED).save
         SystemLog.create(description: "Atualizou #{production_unity.name} do grupo #{production_unity.group.name} no sig Org (Via Atualização em massa)", author: self.user_and_type_of_logged_user)
       end
     end

     return true

   end

   validate :validar_login

   private

   def validar_login
    if(Admin.find_by(login: self.login) or Core.find_by(login: self.login))
      errors.add(:login, "Já está sendo utilizado")
    end
   end


end
