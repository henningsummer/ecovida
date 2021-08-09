class Groups::DacDocumentsController < ApplicationController
  before_action :set_group, only: [:create]
  respond_to :js, :html, :json

  def create
    response = DacDocumentation::Create.execute(dac_document_params, current_user_instance)

    if response && response.valid?
      SystemLog.create(description: "Enviou um DAC para #{@group.name}", author: name_and_type_of_logged_user)
      
      render nothing: true, status: 200
    else
      render nothing: true, status: 400
    end
  end

  private

  def dac_document_params
    params.require(:dac_document).permit(:id, :file, :observations, :dac_date)
                                 .merge(status: :pending, group_id: @group.id)
  end

  def set_group
    @group = Group.find(params[:group_id])
  end
end
