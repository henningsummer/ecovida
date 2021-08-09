class Groups::ProductionUnities::SendDocumentsController < ApplicationController
  before_action :set_group, only: [:index, :create]
  respond_to :js, :html, :json

  def index
    subject = @production_unity.is_agribusiness? ? 'agribusiness' : 'production_unity'
    @documents = Document.where(status: :active, subject: subject)

    @sended_documents = DocumentSended.where(subject: @production_unity)
  end

  def create
    response = DocumentApprovement::Create.execute(document_params.merge(subject: @production_unity), current_user_instance)

    if response && response.valid?
      SystemLog.create(description: "Enviou documento para #{@production_unity.name}",
                       author: name_and_type_of_logged_user)
      render nothing: true, status: 200
    else
      render nothing: true, status: 400
    end
  end

  private

  def document_params
    params.require(:document_sended).permit(:file, :url, :document_id, :observations).merge(status: :pending)
  end

  def set_group
    @production_unity = ProductionUnity.find(params[:production_unity_id])
    @group = @production_unity.group
  end
end
