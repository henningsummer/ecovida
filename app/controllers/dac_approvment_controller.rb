class DacApprovmentController < ApplicationController
  before_action :require_admin

  def create
    @dac_document = DacDocument.find(dac_document_params[:id])

    if params[:commit] == 'Aprovar Documento'
      SystemLog.create(description: "Aprovou a DAC de #{@dac_document.group.try(:name) }", author: name_and_type_of_logged_user)

      response = DacDocumentation::Create.execute(dac_document_params.merge(status: 'accepted'), current_user_instance)
    elsif params[:commit] == 'Rejeitar Documento'
      SystemLog.create(description: "Rejeitou a DAC de #{@dac_document.group.try(:name) }", author: name_and_type_of_logged_user)

      response = DacDocumentation::Create.execute(dac_document_params.merge(status: 'change_request'), current_user_instance)
    end

    if response && response.valid?
      render nothing: true, status: 200
    else
      render nothing: true, status: 400
    end
  end

  def dac_document_params
    params.require(:dac_document).permit(:id, :rejection_reason, :dac_date)
  end
end
