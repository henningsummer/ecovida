# == Schema Information
#
# Table name: certificate_groups
#
#  id              :integer          not null, primary key
#  coordinate_name :string
#  core_name       :string
#  group_name      :string
#  meeting_date    :date
#  meeting_number  :string
#  meeting_page    :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  city_id         :integer
#  group_id        :integer
#
# Indexes
#
#  index_certificate_groups_on_city_id   (city_id)
#  index_certificate_groups_on_group_id  (group_id)
#
# Foreign Keys
#
#  fk_rails_...  (city_id => cities.id)
#  fk_rails_...  (group_id => groups.id)
#
class CertificateGroup < ActiveRecord::Base
  validates_presence_of :meeting_number, :meeting_date, :meeting_page
  validate :custom_validations

  belongs_to :group
  belongs_to :city

  has_many :certificates
  attr_accessor :farmers, :agribusiness

  before_create do
    current_group = Group.find(self.group_id)
    self.core_name = current_group.core.name
    self.group_name = current_group.name
    self.coordinate_name = current_group.core.coordinator.name
  end

  after_create do
      # Gera os certificados para os agricultores

      production_unity_documents = Document.where(subject: 'production_unity', required_for_certificate: 'yes_answer', status: 'active')
      agribusiness_documents     = Document.where(subject: 'agribusiness', required_for_certificate: 'yes_answer', status: 'active')
      farmer_documents           = Document.where(subject: 'farmer', required_for_certificate: 'yes_answer', status: 'active')

      self.farmers.each do |farmer|
        farmer_model = group.farmers.find(farmer.first)

        certificate_type = farmer.second # Retorna o que foi passado pela view

        if certificate_type != "not_generate"
          changes = []
          changes << ['Certificado gerado - Nova validade para certificado' => (self.meeting_date + 365).strftime('%d/%m/%y')]
          farmer_model.update_sig_org(changes)
        end

        if certificate_type == "titular_and_suplent_in_same"
          # Um certificado para os dois
          farmer_certificate = self.certificates.build
          farmer_certificate.certificate_type = 1 # Certificate::CERTIFICATE_TYPES
          farmer_certificate.certificate_group_id = self.id
          farmer_certificate.dac_date = farmer_model.dac_date
          farmer_certificate.city_name = farmer_model.city.name
          farmer_certificate.pruduction_quantity = farmer_model.certificable_production_unities(farmer_documents, production_unity_documents).count
          farmer_certificate.number_type = farmer_model.number_type == 1 ? 'CPF' : 'CNPJ'
          farmer_certificate.number = farmer_model.number_type == 1 ? CPF.new(farmer_model.number).formatted : CNPJ.new(farmer_model.number).formatted
          farmer_certificate.save
          farmer_certificate.certificate_names.create(name: farmer_model.name, farmer_id: farmer_model.id, name_type: "1")

          farmer_model.certificable_production_unities(farmer_documents, production_unity_documents).each do |pu|
            farmer_certificate.certificate_addresses.create(address: pu.full_address)
          end

          generate_certificate_families_for(farmer_certificate, farmer_model)

          if farmer_model.spouse.present?
            farmer_certificate.certificate_names.create(name: farmer_model.spouse, farmer_id: farmer_model.id, name_type: "2")
            farmer_certificate.update(number: "#{farmer_certificate.number}:::#{CPF.new(farmer_model.spouse_cpf).formatted}")
          end

          farmer_model.generate_certificate_products(farmer_certificate)
        elsif certificate_type == "one_to_titular_and_one_to_suplent"
          # Um certificado para cada um
          # O do titular
          titular_certificate = self.certificates.build
          titular_certificate.certificate_type = 2
          titular_certificate.dac_date = farmer_model.dac_date
          titular_certificate.city_name = farmer_model.city.name
          titular_certificate.number =  farmer_model.number_type == 1 ? CPF.new(farmer_model.number).formatted : CNPJ.new(farmer_model.number).formatted
          titular_certificate.number_type = farmer_model.number_type == 1 ? 'CPF' : 'CNPJ'
          titular_certificate.pruduction_quantity = farmer_model.certificable_production_unities(farmer_documents, production_unity_documents).count
          titular_certificate.save
          titular_certificate.certificate_names.create(name: farmer_model.name, farmer_id: farmer_model.id, name_type: "1")
          farmer_model.generate_certificate_products(titular_certificate)
          generate_certificate_families_for(titular_certificate, farmer_model)

          farmer_model.certificable_production_unities(farmer_documents, production_unity_documents).each do |pu|
            titular_certificate.certificate_addresses.create(address: pu.full_address)
          end

          # O do suplente
          supplent_certificate = self.certificates.build
          supplent_certificate.certificate_type = 3
          supplent_certificate.dac_date = farmer_model.dac_date
          supplent_certificate.city_name = farmer_model.city.name
          supplent_certificate.pruduction_quantity = farmer_model.certificable_production_unities(farmer_documents, production_unity_documents).count
          supplent_certificate.number = CPF.new(farmer_model.spouse_cpf).formatted
          supplent_certificate.save
          supplent_certificate.certificate_names.create(name: farmer_model.name, farmer_id: farmer_model.id, name_type: "1")
          supplent_certificate.certificate_names.create(name: farmer_model.spouse, farmer_id: farmer_model.id, name_type: "2")
          farmer_model.generate_certificate_products(supplent_certificate)
          generate_certificate_families_for(supplent_certificate, farmer_model)

          farmer_model.certificable_production_unities(farmer_documents, production_unity_documents).each do |pu|
            supplent_certificate.certificate_addresses.create(address: pu.full_address)
          end
        end
      end

      # Gera os certificados para as agroindustrias
      self.agribusiness.each do |agribusiness|
        # AQUI #
        agribusiness_model = group.production_unities.find(agribusiness.first)
        certification_type = agribusiness.second

        if certification_type != "not_generate"
          changes = []
          changes << ['Certificado gerado - Nova validade para certificado' => (self.meeting_date + 365).strftime('%d/%m/%y')]
          agribusiness_model.update_sig_org(changes)
        end

        if certification_type == "generate_for_agribusiness"

          #Apenas para razão social

          agribusiness_certificate = self.certificates.build
          agribusiness_certificate.certificate_type = 4
          agribusiness_certificate.dac_date = agribusiness_model.dac_date
          agribusiness_certificate.city_name = agribusiness_model.city.name
          if agribusiness_model.number
            agribusiness_certificate.number = agribusiness_model.number_type == 2 ? CNPJ.new(agribusiness_model.number).formatted : CPF.new(agribusiness_model.number).formatted
            agribusiness_certificate.number_type = agribusiness_model.number_type == 2 ? 'CNPJ' : 'CPF'
          end
          agribusiness_certificate.save
          agribusiness_certificate.certificate_names.create(
            name: "#{agribusiness_model.name}",
            production_unity_id: agribusiness_model.id,
            name_type: "3",
            number: agribusiness_model.number,
            number_type: agribusiness_model.number_type
          )

          agribusiness_certificate.certificate_names.create(
            name: agribusiness_model.responsible.name,
            farmer_id: agribusiness_model.responsible.id,
            name_type: "4"
          )

          agribusiness_certificate.certificate_addresses.create(address: agribusiness_model.full_address)

          generate_agribusiness_products(agribusiness_model, agribusiness_certificate)

        elsif certification_type == "to_members"

          #Para os membros

          agribusiness_model.agribusiness_farmers_thar_can_receive_certificate(agribusiness_documents,
                                                                               farmer_documents,
                                                                               production_unity_documents).each do |farmer|
              agribusiness_certificate = self.certificates.build
              agribusiness_certificate.certificate_type = 5
              agribusiness_certificate.dac_date = agribusiness_model.dac_date
              agribusiness_certificate.city_name = agribusiness_model.city

              farmer_number =  farmer.number_type == 1 ? CPF.new(farmer.number).formatted : CNPJ.new(farmer.number).formatted
              farmer_number_type = farmer.number_type == 1 ? 'CPF' : 'CNPJ'
              agribusiness_number = agribusiness_model.number_type == 2 ? CNPJ.new(agribusiness_model.number).formatted : CPF.new(agribusiness_model.number).formatted
              agribusiness_number_type = agribusiness_model.number_type == 2 ? 'CNPJ' : 'CPF'

              agribusiness_certificate.number_type = agribusiness_number_type
              agribusiness_certificate.number = "#{farmer_number_type}: <u> #{farmer_number} </u> :::#{agribusiness_number}"

              agribusiness_certificate.save
              agribusiness_certificate.certificate_names.create(
                name: agribusiness_model.name,
                production_unity_id: agribusiness_model.id,
                name_type: "3",
                number: agribusiness_model.number,
                number_type: agribusiness_model.number_type
              )

              generate_agribusiness_products(agribusiness_model, agribusiness_certificate)
              generate_certificate_families_for(agribusiness_certificate, farmer)

              agribusiness_certificate.certificate_addresses.create(address: agribusiness_model.full_address)

              agribusiness_certificate.certificate_names.create(
                name: farmer.name,
                farmer_id: farmer.id,
                name_type: "4"
              )

              if farmer.spouse.present?
                agribusiness_certificate.certificate_names.create(name: farmer.spouse, farmer_id: farmer.id, name_type: "2")
                agribusiness_certificate.update(number: "#{agribusiness_certificate.number}:::#{farmer.spouse_cpf}")
              end
            end
        end
      end
  end

  private

  def generate_certificate_families_for(certificate, farmer)
    farmer.farmer_families.each do |farmer_family|
      certificate.certificate_families.create(farmer_family: farmer_family,
                                              name: farmer_family.name)
    end
  end

  def generate_agribusiness_products(agribusiness_model, agribusiness_certificate)
    agribusiness_model.products.each do |product|
      agribusiness_certificate.certificate_products.create(
      name: product.product.name,
      product_id: product.product.id,
      contain_organic: product.is_processor
      )
    end
  end

  def custom_validations
    count = 0
    # Verificando agricultores #
    if farmers.present? or agribusiness.present?
    	self.farmers.each do |farmer|
    		farmer_model = group.farmers.where(id: farmer.first) #farmer.first = id
    		if farmer_model.count != 0
    			unless farmer_model.first.can_have_certificate?
    				errors.add(:group, "Agricultor não permitido.")
    			end
          count += 1 if farmer.second != "not_generate"
    		else
    			errors.add(:group, "Agricultor não encontrado.")
    		end
    	end

      # Verificando agroindustrias #
      self.agribusiness.each do |agribusiness|
        agribusiness_model = group.production_unities.where(id: agribusiness.first)
        if agribusiness.count != 0
          unless agribusiness_model.first.can_have_certificate?
            errors.add(:group, "Não pode receber certificado")
          end
          count += 1 if agribusiness.second != "not_generate"

        else
          errors.add(:group, "Agroindustria não encontrada.")
        end
      end
    end
    # Não vai gerar nenhum ?
    errors.add(:group_id, "- Não foi selecionado nenhum certificado para ser gerado") if count == 0
    # Verificando se possuí um coordenador.
    errors.add(:group_id, "- Não é possível gerar certificados.  O Núcleo não possuí um coordenador cadastrado.") if group.core.core_coordinators.count == 0
  end

end
