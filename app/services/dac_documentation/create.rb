module DacDocumentation
  class Create
    class << self
      def execute(params, current_user)
        if ['accepted', 'change_request'].include? params[:status]
          document = DacDocument.find(params[:id])
          document.status = params[:status]
          document.rejection_reason = params[:rejection_reason] if params[:rejection_reason]
          document.approved_at = Time.now.utc if params[:status] == 'accepted'
          document.dac_date = "#{params["dac_date(3i)"]}/#{params["dac_date(2i)"]}/#{params["dac_date(1i)"]}" if params["dac_date(3i)"] && params[:status] == 'accepted'
        else
          id = params[:id]

          if id
            document = DacDocument.find(id)
            document.observations = params[:observations]
          else
            document = DacDocument.new(params.except(:file))
          end

          document.dac_date = "#{params["dac_date(3i)"]}/#{params["dac_date(2i)"]}/#{params["dac_date(1i)"]}" if params["dac_date(3i)"]
          document.status = params[:status] if params[:status]
        end

        document.dac_date = "#{params["dac_date(3i)"]}/#{params["dac_date(2i)"]}/#{params["dac_date(1i)"]}" if params["dac_date(3i)"]
        document.file = params[:file] if params[:file]

        return false unless can_upload_document(document, current_user)
        document.save

        document
      end

      private

      def can_upload_document(document, current_user)
        return true if current_user.class.to_s == 'Admin'
        current_user_core = current_user.class.to_s == 'Core' ? current_user.id : current_user.core_id

        return false if document.group.core_id != current_user_core

        true
      end
    end
  end
end
