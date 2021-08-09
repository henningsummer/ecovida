module DocumentApprovement
  class Verify
    class << self
      def verify_document_for(subject)
        documents = Document.where(subject: subject_for(subject))

        pendents = []
        documents.each do |document|
          sended = DocumentSended.find_by(document: document, subject: subject)
          unless sended.present?
            pendents << { document: document, status: 'Documento não enviado' }
            next
          end

          case sended.status
          when 'pending'
            pendents << { document: document, status: 'Documento enviado e aguardando aprovação' }
          when 'change_request'
            pendents << { document: document, status: 'Documento enviado, porém, OPAC recusou devido a problemas no mesmo.' }
          end
        end

        pendents
      end

      private

      def subject_for(subject)
        if subject.class == Farmer
          'farmer'
        elsif subject.class == Group
          'core_group'
        elsif subject.class == ProductionUnity
          return 'agribusiness' if subject.is_agribusiness?
          'production_unity'
        end
      end
    end
  end
end
