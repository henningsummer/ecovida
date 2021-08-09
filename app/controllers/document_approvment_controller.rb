class DocumentApprovmentController < ApplicationController
  before_action :require_admin

  def index
    @dacs = DacDocument.where(status: 'pending')
    @documents = DocumentSended.where(status: 'pending')
  end

  def create
    @document_sended = DocumentSended.find(document_params[:id])
    
    if params[:commit] == 'Aprovar Documento'
      SystemLog.create(description: "Aprovou o documento #{@document_sended.document.name} de #{@document_sended.subject.try(:name) }", author: name_and_type_of_logged_user)
      
      response = DocumentApprovement::Create.execute(document_params.merge(status: 'accepted'), current_user_instance)
    elsif params[:commit] == 'Rejeitar Documento'
      SystemLog.create(description: "Rejeitou o documento #{@document_sended.document.name} de #{@document_sended.subject.try(:name) }", author: name_and_type_of_logged_user)
      
      response = DocumentApprovement::Create.execute(document_params.merge(status: 'change_request'), current_user_instance)
    end

    if response && response.valid?
      render nothing: true, status: 200
    else
      render nothing: true, status: 400
    end
  end

  def document_params
    params.require(:document_sended).permit(:id, :rejection_reason)
  end
end
