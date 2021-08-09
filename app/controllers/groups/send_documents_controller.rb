class Groups::SendDocumentsController < ApplicationController
  before_action :set_group, only: [:index, :create]
  respond_to :js, :html, :json

  def index
    @documents = Document.where(status: :active, subject: 'core_group')
    @sended_documents = DocumentSended.where(subject: @group)
    @dac_document = @group.dac_documents.try(:last)

    if @dac_document.present?
      if ['pending', 'change_request'].include? @dac_document.status
        @need_resend_dac = true
      else
        @need_resend_dac = false
      end
    else
      @need_resend_dac = false
    end
  end

  def create
    response = DocumentApprovement::Create.execute(document_params.merge(subject: @group), current_user_instance)

    if response && response.valid?
      SystemLog.create(description: "Criou documento para #{@group.name}", author: name_and_type_of_logged_user)
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
    @group = Group.find(params[:group_id])
  end
end
