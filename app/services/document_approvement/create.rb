module DocumentApprovement
  class Create
    class << self
      def execute(params, current_user)
        document_history = nil

        if ['accepted', 'change_request'].include? params[:status]
          is_admin = true
          is_invalid = false
          document = DocumentSended.find(params[:id])
          document.status = params[:status]
          document.rejection_reason = params[:rejection_reason] if params[:rejection_reason]
          document.approved_at = Time.now.utc if params[:status] == 'accepted'
        else
          document = DocumentSended.find_or_initialize_by(params.slice(:subject_id, :subject, :document_id))
          if document.status == 'accepted' && params[:status].to_s != 'accepted'
            document_history = DocumentSendedHistory.new(document_sended: document, approved_at: document.approved_at, url: document.url)
            if document.file.file
              CopyCarrierwaveFile::CopyFileService.new(document, document_history, :file).set_file
            end
            document_history.save
          end

          unless params[:file].present?
            begin
              if params[:url]
                document.remove_file!
                document.file = nil
                document.send(:write_attribute, :file, nil)
                document.save
              end
            rescue
            end

            is_invalid = !params[:file].present? && !params[:url].present?
            is_admin = false
          end

          document.url = nil unless params[:url].present?
        end

        document.status = params[:status]
        document.file = params[:file] if params[:file]
        document.url = params[:url] if params[:url]
        document.observations = params[:observations] if params[:observations]

        unless can_upload_document(document, current_user)
          document_history.try(:destroy)
          return false
        end

        begin
          document.save
        rescue
        end

        if is_invalid && !is_admin
          document.file = nil
          document.url = nil
          document.subject_id = nil
        end

        document_history.try(:destroy) unless document.valid?

        document
      end

      private

      def can_upload_document(document, current_user)
        return true if current_user.class.to_s == 'Admin'
        current_user_core = current_user.class.to_s == 'Core' ? current_user.id : current_user.core_id

        case document.subject_type
        when 'Farmer', 'ProductionUnity'
          return false if document.subject.group.core_id != current_user_core
        when 'Group'
          return false if document.subject.core_id != current_user_core
        end

        true
      end
    end
  end
end
