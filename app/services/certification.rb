class Certification
  class << self
    def verify_and_list(group, only_group = false)
      group_documents = Document.where(subject: 'core_group', required_for_certificate: 'yes_answer', status: 'active')

      group_sended_documents = DocumentSended.where(subject: group)

      group_analysis = verify_documents_for(group, group_documents, group_sended_documents)

      if group.expirated_dac? || group.dac_documents.try(:last).try(:status) != 'accepted'
        group_analysis.has_document = false

        if group.dac_documents.any?
          if group.dac_documents.last.dac_date && group.dac_documents.last.status == 'accepted' && group.expirated_dac?
            group_analysis.dac = 'expirated'
          else
            group_analysis.dac = group.dac_documents.last.status
          end
        else
          group_analysis.dac = 'missing'
        end

        return group_analysis
      else
        group_analysis.dac = 'accepted'

        return group_analysis unless group_analysis.has_document
        return group_analysis if only_group

        group_analysis.farmers = []
        return group_analysis unless group_analysis.has_document
        return group_analysis if only_group

        group_analysis.farmers = []
        group_analysis.agribusiness = []

        production_unity_documents = Document.where(subject: 'production_unity', required_for_certificate: 'yes_answer', status: 'active')
        agribusiness_documents     = Document.where(subject: 'agribusiness', required_for_certificate: 'yes_answer', status: 'active')
        farmer_documents           = Document.where(subject: 'farmer', required_for_certificate: 'yes_answer', status: 'active')

        group.farmers.each do |farmer|
          group_analysis.farmers << verify_farmer(farmer, farmer_documents, production_unity_documents)
        end

        group.production_unities.where(scope_type: 2).each do |ag|
          group_analysis.agribusiness << verify_agribusiness(ag, agribusiness_documents, farmer_documents, production_unity_documents)
        end

        group_analysis
      end
    end

    def verify_agribusiness(agribusiness, agribusiness_documents, farmer_documents, production_unity_documents)
      farmer_documents           ||= Document.where(subject: 'farmer', required_for_certificate: 'yes_answer', status: 'active')
      agribusiness_documents     ||= Document.where(subject: 'agribusiness', required_for_certificate: 'yes_answer', status: 'active')
      production_unity_documents ||= Document.where(subject: 'production_unity', required_for_certificate: 'yes_answer', status: 'active')

      agribusiness_sendeds = DocumentSended.where(subject: agribusiness)

      agribusiness_analysis = verify_documents_for(agribusiness, agribusiness_documents, agribusiness_sendeds)

      agribusiness_analysis.suspended = agribusiness.is_suspended?
      agribusiness_analysis.has_products = agribusiness.products.count > 0
      agribusiness_analysis.in_transaction = agribusiness.production_type == 'Em transição'
      agribusiness_analysis.farmer_with_documents = false
      agribusiness_analysis.farmers = []

      agribusiness.farmers.each do |farmer|
        farmer_analysis = verify_farmer(farmer, farmer_documents, production_unity_documents)
        agribusiness_analysis.farmers << farmer_analysis
        agribusiness_analysis.farmer_with_documents = true if farmer_analysis.can_generate_agribusiness
      end

      can = !agribusiness_analysis.suspended && agribusiness_analysis.has_products && !agribusiness_analysis.in_transaction && agribusiness_analysis.has_document &&  agribusiness_analysis.farmer_with_documents
      agribusiness_analysis.can_receive_certificate = can

      agribusiness_analysis
    end

    def verify_production_unity(production_unity, production_unity_documents)
      production_unity_documents ||= Document.where(subject: 'production_unity', required_for_certificate: 'yes_answer', status: 'active')

      production_unity_sendeds = DocumentSended.where(subject: production_unity)

      production_unity_analysis = verify_documents_for(production_unity, production_unity_documents, production_unity_sendeds)

      production_unity_analysis.suspended = production_unity.is_suspended?
      production_unity_analysis.has_products = production_unity.products.count > 0
      production_unity_analysis.in_transaction = production_unity.production_type == 'Em transição'

      can = !production_unity_analysis.suspended && production_unity_analysis.has_products && !production_unity_analysis.in_transaction && production_unity_analysis.has_document
      production_unity_analysis.can_receive_certificate = can

      production_unity_analysis
    end

    def verify_farmer(farmer, farmer_documents, production_unity_documents)
      production_unity_documents ||= Document.where(subject: 'production_unity', required_for_certificate: 'yes_answer', status: 'active')
      farmer_documents           ||= Document.where(subject: 'farmer', required_for_certificate: 'yes_answer', status: 'active')

      farmer_sendeds = DocumentSended.where(subject: farmer)

      farmer_analysis = verify_documents_for(farmer, farmer_documents, farmer_sendeds)

      farmer_analysis.suspended = farmer.is_suspended?

      farmer_analysis.production_unities = []

      farmer.production_unities.each do |production_unity|
        farmer_analysis.production_unities << verify_production_unity(production_unity, production_unity_documents)
      end

      farmer_analysis.dac_valid = farmer.dac_valid?

      can_agribusiness = !farmer_analysis.suspended && farmer_analysis.has_document && farmer_analysis.dac_valid
      farmer_analysis.can_receive_certificate = can_agribusiness && farmer_analysis.production_unities.select { |pu| pu.can_receive_certificate }.any?
      farmer_analysis.can_generate_agribusiness = can_agribusiness

      farmer_analysis
    end

    private

    def verify_documents_for(subject, documents, sendeds)
      missing = []

      documents.each do |document|
        sended = sendeds.select { |sd| sd.document_id == document.id }.try(:first)
        missing << { document: document, status: sended.try(:status) || 'missing' } unless sended.try(:status) == 'accepted'
      end

      OpenStruct.new(subject: subject, has_document: missing.empty?, missing: missing)
    end
  end
end
