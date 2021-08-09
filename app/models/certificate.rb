# == Schema Information
#
# Table name: certificates
#
#  id                   :integer          not null, primary key
#  certificate_type     :string
#  city_name            :string
#  dac_date             :datetime
#  number               :string
#  number_type          :string
#  pruduction_quantity  :integer
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  certificate_group_id :integer
#
# Indexes
#
#  index_certificates_on_certificate_group_id  (certificate_group_id)
#
# Foreign Keys
#
#  fk_rails_...  (certificate_group_id => certificate_groups.id)
#
class Certificate < ActiveRecord::Base
  # Descrição dos tipos de certificado:
  # - titular_suplent_in_same:
  # Tem 2 certificates_names - 1: Titular (tipo 1), 2: Suplent (tipo 2)
  # - farmer_singular_titular \ supplent:
  # Tem 1 certificate_name com o titular \ suplente
  # - agribusiness_social_name
  # Tem 1 certificate_name com a razão social
  # - agribusiness_member_name
  # Tem 1 certificate name com a razão social da agroindustria e 1 ou mais
  # certificates_names com o nome dos membros.
  CERTIFICATE_TYPES = {"farmer_titular_suplent_in_same" => 1,
                       "farmer_singular_titular" => 2,
                       "farmer_singular_supplent" => 3,
                       "agribusiness_social_name" => 4,
                       "agribusiness_member_name" => 5
  }

  PRODUCTION_UNITY_ADDRESS = 'Endereço da unidade produtiva'
  PRODUCTION_UNITY_ADDRESS_PLURAL = 'Endereços das unidades produtivas'
  AGRIBUSINESS_ADDRESS = 'Endereço da agroindústria'
  AGRIBUSINESS_ADDRESS_PLURAL = 'Endereço das agroindústrias'

  has_many :certificate_names
  has_many :certificate_families
  has_many :certificate_products
  has_many :certificate_addresses
  belongs_to :certificate_group

  def certificate_subject_name
    if [1,2,3].include? certificate_type.to_i
      return "propriedade"
    end
    "agroindústria"
  end

  def certificate_id
    Farmer.unscoped {
      if certificate_type == "1" || certificate_type == "3"
        return titular.farmer_code
      elsif certificate_type == "2"
        return titular.farmer_code
      elsif certificate_type == "4" || certificate_type == "5"
        return agribusiness_member_name.farmer_code
      end
    }
  end

  def text_number(name = 'Titular')
    return "" unless number

    case certificate_type
    when "1"
      return ", #{number_type.upcase}: <u>#{number.split(':::')[0]}</u>, ".html_safe if name == 'Titular'
      ", CPF: <u>#{number.split(':::')[1]}</u>, ".html_safe
    when "2"
      ", #{number_type.upcase}: <u>#{number}</u>, ".html_safe
    when "3"
      ", CPF: <u>#{number}</u>, ".html_safe
    when "4"
      ", #{number_type.upcase}: <u>#{number}</u>, ".html_safe
    when "5"
      return ", #{number_type}: #{number.split(':::')[1]}, " if name == 'Titular'
      return ", CPF: #{number.split(':::')[2]}, " if name == 'Suplente'
      ", #{number.split(':::')[0]}, ".html_safe
    end
  end

  def scopes
    certificate_products.map(&:product).map(&:product_category).map(&:scope).uniq.map(&:name)
  end

  def addresses_text
    number = 1
    text = '<p class = "certificate_text_2" align = left>'
    addresses = certificate_addresses.map(&:address).each do |address|
      if number == 1
        text << text_for_one(address)
      else
        text << text_for_two(address)
      end
      number = number + 1
    end

    text << '</p>'
    text.html_safe
  end

  def text_for_one(address)
    if certificate_addresses.count == 1
      if [1,2,3].include? certificate_type.to_i
        "<b>#{PRODUCTION_UNITY_ADDRESS}:</b>&nbsp;#{address}; &nbsp;"
      else
        "<b>#{AGRIBUSINESS_ADDRESS}:</b> &nbsp;#{address}"
      end
    else
      if [1,2,3].include? certificate_type.to_i
        "<b>#{PRODUCTION_UNITY_ADDRESS_PLURAL}:</b>&nbsp;#{address}; &nbsp;"
      else
        "<b>#{AGRIBUSINESS_ADDRESS_PLURAL}:</b> &nbsp;#{address}"
      end
    end
  end

  def text_for_two(address)
    text = ""
    text << "#{address};&nbsp; "
    text
  end

  def cnpj
    CNPJ.new(razao_social.number).formatted
  end

  def titular
    certificate_names.where(name_type: 1).first
  end

  def suplente
    certificate_names.where(name_type: 2).first
  end

  def razao_social
    certificate_names.where(name_type: 3).first
  end

  def agribusiness_member_name
    certificate_names.where(name_type: 4).first
  end

  def description
    Farmer.unscoped {
      if self.certificate_type == "1"
        titular = self.certificate_names.where(name_type: "1").first
        supplent = self.certificate_names.where(name_type: "2").first
        text = "Certificado do membro #{titular.name} (#{titular.farmer_code})"
        text << " e 2º titular #{supplent.name}" if supplent.present?
        text
      elsif self.certificate_type == "2"
        titular = self.certificate_names.where(name_type: "1").first
        "Certificado com um nome do membro #{titular.name} (#{titular.farmer_code})."
      elsif self.certificate_type == "3"
        supplent = self.certificate_names.where(name_type: "2").first
        "Certificado pertencente ao 2º titular #{supplent.name}. Ele é 2º titular do agricultor de código #{supplent.farmer_code}"
      elsif self.certificate_type == "4"
        agribusiness = self.certificate_names.first
        "Certificado pertencente à agroindústria #{agribusiness.name}.  Certificado com a razão social."
      elsif self.certificate_type == "5"
        agribusiness = self.certificate_names.where(name_type: "3").first
        farmer = self.certificate_names.where(name_type: "4").first
        text = "Certificado pertencente à agroindústria #{agribusiness.name}, para o membro: #{farmer.name} - #{farmer.farmer_code}"
        text
      end
    }
  end

  def referent_model
    Farmer.unscoped {
      if ["1","2","3"].include? self.certificate_type
        [self.certificate_names.first.farmer.group, self.certificate_names.first.farmer] unless self.certificate_names.first.farmer.excluded
      else
        ProductionUnity.unscoped {
          production_unity = self.certificate_names.where(name_type: "3").first.production_unity
          [production_unity.group, production_unity] unless production_unity.excluded?
        }
      end
    }
  end
end
