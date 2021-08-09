class Farmers::SendDocumentsController < ApplicationController
  before_action :set_farmer, only: [:index, :create]
  respond_to :js, :html, :json

  def index
    @documents = Document.where(status: :active, subject: 'farmer')
    @sended_documents = DocumentSended.where(subject: @farmer)
  end

  def create
    response = DocumentApprovement::Create.execute(document_params.merge(subject: @farmer), current_user_instance)

    if response && response.valid?
      SystemLog.create(description: "Enviou documento para #{@farmer.name}", author: name_and_type_of_logged_user)
      
      render nothing: true, status: 200
    else
      render nothing: true, status: 400
    end
  end

  private

  def document_params
    params.require(:document_sended).permit(:file, :url, :document_id, :observations).merge(status: :pending)
  end

  def set_farmer
    @farmer = Farmer.find(params[:farmer_id])
    @group = @farmer.group
  end
end
