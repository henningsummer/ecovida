# coding: utf-8
module Reports
  require 'csv'

  class CertificatesReport
    def initialize(core_id: nil, from: nil, to: nil, email: nil)
      @core_id =  core_id
      @from = from ? DateTime.parse(from) : (DateTime.now - 1.year).beginning_of_year
      @to = to ? DateTime.parse(to) : (DateTime.now - 1.year).end_of_year
      @email = email
    end

    def process
      cores = @core_id.present? ? [Core.find(@core_id)] : Core.all

      generate_csv(cores)
    end

    def generate_csv(cores)
      csv_base = [report_csv_columns]
      farmers = find_farmers_to_certificate(cores)

      csv_base = populate_csv_farmers(csv_base, farmers)

      agribusiness = find_agribusiness_to_certificate(cores)

      csv_base = populate_csv_agribussiness(csv_base, agribusiness)
      csv_parsed = csv_base.map { |x| CSV.generate_line(x, col_sep: '|') }.join

      file_name = "tmp/certificate_report#{Time.now.to_s}.csv"

      File.binwrite(file_name, csv_parsed)

      ReportSender.delay.report_sender(@email, email_name, file_name, 'relatorio_certificados', 'csv')
    end

    def populate_csv_agribussiness(csv_base, agribusiness)
      agribusiness[:farmers].each do |_k, farmer|
        farmer[:cpf] = nil

        city = farmer[:city]

        csv_base << generate_farmer_lines(farmer[:farmer].name, farmer)
        csv_base << generate_farmer_lines(farmer[:farmer].spouse, true, farmer) if farmer[:farmer].spouse.present?

        farmer[:farmer].farmer_families.each do |family|
          next unless family.cpf.present?

          farmer[:cpf] = family.cpf

          csv_base << generate_farmer_lines(family.name, farmer)
        end
      end

      agribusiness[:agribusiness].each do |_k, agribusiness|
        csv_base << generate_agribusiness_lines(agribusiness)
      end

      csv_base
    end

    def generate_agribusiness_lines(model:, products:, scopes:)
      Farmer.unscoped do
        [
          '',
          '',
          '',
          model.city.state.uf,
          model.city.name,
          '',
          model.number,
          model.responsible.farmer_code,
          model.name,
          scopes.join(', '),
          products.sort.join(', '),
          model.phone.present? ? model.phone : '',
          model.group.name
        ]
      end
    end

    def find_agribusiness_to_certificate(cores)
      certificates = Certificate.joins(certificate_group: :group)
                                .where(groups: { core_id: cores.map(&:id) })
                                .where(certificate_type: ['4', '5'])
                                .where(['certificate_groups.meeting_date >= :from AND certificate_groups.meeting_date <= :to',
                                        from: @from, to: @to]).order(created_at: :desc)

      response = { agribusiness: [], farmers: [] }

      already_imported = []

      certificates.each do |certificate|
        if certificate.certificate_type == '4'
          Group.unscoped do
            ProductionUnity.unscoped do
              next unless certificate.referent_model.present?

              # referent_model[1] == production_unity
              next if certificate.referent_model == nil
              next if certificate.referent_model[1].is_suspended?
              next if certificate.referent_model[1].excluded
              next if already_imported.include?(certificate.referent_model[1])
              next unless certificate.certificate_products.where(contain_organic: false).any?

              products_for_agribiness = certificate.certificate_products.where(contain_organic: false).select { |cert| !cert.certificate.referent_model[1]&.excluded }

              already_imported << certificate.referent_model[1]

              response[:agribusiness] << { model: certificate.referent_model[1], city: certificate.referent_model[1].city.name,
                                           products: products_for_agribiness.map(&:name),
                                           scopes: agribusiness_scopes_for(certificate) }
            end
          end
        else
          Farmer.unscoped do
            farmer_model = certificate.certificate_names.find_by_name_type('4').farmer

            next if farmer_model.excluded
            next if farmer_model.is_suspended?
            next if certificate.referent_model == nil
            next if already_imported.include?(farmer_model)

            already_imported << farmer_model

            next unless certificate.certificate_products.where(contain_organic: false).any?

            response[:farmers] << { farmer: farmer_model, city: agribusiness_city_for(certificate) || certificate.referent_model[1].city.name,
                                    products: certificate.certificate_products.where(contain_organic: false).map(&:name),
                                    scopes: agribusiness_scopes_for(certificate) }
          end
        end
      end

      response[:farmers] = unify_titulars(response[:farmers])
      response[:agribusiness] = unify_agribusiness(response[:agribusiness])
      response
    end

    def agribusiness_city_for(certificate)
      certificate.certificate_names.find_by_name_type('3')
        .production_unity&.city&.name
    end

    def agribusiness_scopes_for(certificate)
      ProductionUnity.unscoped do
        certificate.certificate_names.find_by_name_type('3')
                   .production_unity.production_unity_scopes
                   .map(&:scope).map(&:name).join(', ')
      end
    end

    def email_name
      return 'Relatório de certificados para todos os núcleos' unless @core_id.present?
      core = Core.find(@core_id)

      "Relatório de certificados para o núcleo #{core.name}"
    end

    def populate_csv_farmers(csv_base, farmers)
      farmers.each do |_k, farmer|
        farmer[:cpf] = nil

        csv_base << generate_farmer_lines(farmer[:farmer].name, farmer)
        csv_base << generate_farmer_lines(farmer[:farmer].spouse, true, farmer) if farmer[:farmer].spouse.present?

        farmer[:farmer].farmer_families.each do |family|
          next unless family.cpf.present?
          
          farmer[:cpf] = family.cpf

          csv_base << generate_farmer_lines(family.name, farmer)
        end
      end

      csv_base
    end

    def generate_farmer_lines(name, is_spouse = false, farmer:, products:, cpf:, scopes: nil, city:)
      [
        '',
        '',
        '',
        farmer.city.state.uf,
        city,
        '',
        is_spouse ? farmer.spouse_cpf.gsub('.', '').gsub('-', '') : (cpf.present? ? cpf : farmer.number),
        farmer.farmer_code,
        name,
        scopes.present? ? scopes.join(', ') : farmer_scopes(farmer),
        products.sort.join(', '),
        [farmer.phone_number.present? ? farmer.phone_number : nil, farmer.cell_phone.present? ? farmer.cell_phone : nil].compact.join(', '),
        farmer.group.name
      ]
    end

    def farmer_scopes(farmer)
      farmer.production_unities.map(&:production_unity_scopes)
            .flatten.map(&:scope).map(&:name).join(', ')
    end

    def find_farmers_to_certificate(cores)
      certificates = Certificate.joins(certificate_group: :group)
                                .where(groups: { core_id: cores.map(&:id) })
                                .where(certificate_type: ['1', '2'])
                                .where(['certificate_groups.meeting_date >= :from AND certificate_groups.meeting_date <= :to',
                                        from: @from, to: @to])
      titulars = certificates.map do |certificate|
        next unless certificate.referent_model.present?

        Farmer.unscoped do
          next if farmer_scopes(certificate.titular.farmer) == ""

          titular = certificate.titular.farmer
          (titular.excluded || titular.is_suspended?) ? nil : { farmer: titular, 
                                                                products: certificate.certificate_products.map(&:name) } 
        end
      end.compact

      unify_titulars(titulars)
    end

    def unify_titulars(titulars)
      {}.tap do |parsed_titulars|
        titulars.each do |titular|
          titular_number = "#{ titular[:farmer].number } #{ titular[:farmer].id }"
          city = titular[:farmer].production_unities.any? ? titular[:farmer].production_unities.map(&:city).map(&:name).uniq.join('; ') : titular[:farmer].agribusiness.any? ? titular[:farmer].agribusiness.map(&:city).map(&:name).uniq.join('; ') : titular[:farmer].city.name
          parsed_titulars[titular_number] ||= {}
          parsed_titulars[titular_number][:farmer] ||= titular[:farmer]
          parsed_titulars[titular_number][:city] ||= city
          parsed_titulars[titular_number][:products] ||= []
          parsed_titulars[titular_number][:products] << titular[:products]
          parsed_titulars[titular_number][:products] = parsed_titulars[titular_number][:products].flatten.uniq
          if titular[:scopes]
            parsed_titulars[titular_number][:scopes] ||= []
            parsed_titulars[titular_number][:scopes] << titular[:scopes]
            parsed_titulars[titular_number][:scopes] = parsed_titulars[titular_number][:scopes].flatten.uniq
          end
        end
      end
    end

    def unify_agribusiness(agribusiness)
      {}.tap do |parsed_agribusiness|
        agribusiness.each do |agribusines|
          agribusines_number = "#{ agribusines[:model].number } #{ agribusines[:model].id }"
          parsed_agribusiness[agribusines_number] ||= {}
          parsed_agribusiness[agribusines_number][:model] ||= agribusines[:model]
          parsed_agribusiness[agribusines_number][:products] ||= []
          parsed_agribusiness[agribusines_number][:products] << agribusines[:products]
          parsed_agribusiness[agribusines_number][:products] = parsed_agribusiness[agribusines_number][:products].flatten.uniq
          if agribusines[:scopes]
            parsed_agribusiness[agribusines_number][:scopes] ||= []
            parsed_agribusiness[agribusines_number][:scopes] << agribusines[:scopes]
            parsed_agribusiness[agribusines_number][:scopes] = parsed_agribusiness[agribusines_number][:scopes].flatten.uniq
          end
        end
      end
    end
    
    def report_csv_columns
      ['TIPO DE ENTIDADE', 'ENTIDADE', 'PAIS', 'UF', 'CIDADE', 'SITUACAO CNPO', 'CPF/CNPJ/NIF', 'CÓDIGO ECOVIDA', 'NOME DO PRODUTOR',
       'ESCOPO', 'ATIVIDADES', 'CONTATO', 'GRUPO']
    end

    handle_asynchronously :process
  end
end
