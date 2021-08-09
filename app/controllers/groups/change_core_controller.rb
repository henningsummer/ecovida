class Groups::ChangeCoreController < ApplicationController
  before_action :set_group

  before_action do
    require_admin
  end

  def new; end

  def create
    core = Core.find(params[:group][:core_id])
    success = GroupService.new(@group).change_to_core(core)

    if success
      SystemLog.create(description: "Alterou #{@group.name} para o núcleo #{core.name}", author: name_and_type_of_logged_user)
      redirect_to [@group], notice: 'Núcleo alterado com sucesso'
    elsif true
      render :new, alert: 'Não foi possível alterar o núcleo'
    end
  end

  private

  def set_group
    @group = Group.find(params[:group_id])
  end
end
