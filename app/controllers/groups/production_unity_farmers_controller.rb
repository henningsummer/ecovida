class Groups::ProductionUnityFarmersController < ApplicationController
  before_action :set_group_and_production_unity
  before_action do
    require_current_or_admin(@group.core.id)
  end
  def new
    @production_unity_farmer = @production_unity.production_unity_farmers.build
  end
  def create
    @production_unity_farmer = @production_unity.production_unity_farmers.build(production_unity_farmer_params)
    if @production_unity_farmer.save!
      SystemLog.create(description: "Vinculou o #{@production_unity_farmer.farmer.name} (#{@production_unity_farmer.farmer.farmer_code}) a unidade de produção #{@production_unity_farmer.production_unity.name} do grupo #{@group.name}", author: name_and_type_of_logged_user)
      redirect_to [@group, @production_unity], notice: "Vinculo criado com sucesso"
    else
      render :new
    end
  end

  def destroy
    @production_unity_farmer = @production_unity.production_unity_farmers.find(params[:id])
    if not @production_unity_farmer.is_responsible
      if @production_unity_farmer.destroy!
        SystemLog.create(description: "Removeu o vinculo de #{@production_unity_farmer.farmer.name} (#{@production_unity_farmer.farmer.farmer_code}) a unidade de produção #{@production_unity_farmer.production_unity.name} do grupo #{@group.name}", author: name_and_type_of_logged_user)
        redirect_to [@group, @production_unity], notice: "Vinculo desfeito com sucesso"
      else
        redirect_to [@group, @production_unity], notice: "Não foi possível desfazer o vinculo"
      end
    end
  end

  def change_responsible
    @production_unity_farmer = @production_unity.production_unity_farmers.find(params[:production_unity_farmer_id])
    if not @production_unity_farmer.is_responsible
      if @production_unity_farmer.turn_responsible
        redirect_to [@group, @production_unity], notice: "Responsável alterado com sucesso"
        SystemLog.create(description: "Alterou o responsável da unidade de produção #{@production_unity_farmer.production_unity.name} do grupo #{@group.name}.  Novo responsável: #{@production_unity_farmer.production_unity.responsible.name}", author: name_and_type_of_logged_user)
      else
        redirect_to [@group, @production_unity], notice: "Não foi possível alterar o responsável."
      end
    end
  end

  private

  def set_group_and_production_unity
    @group = Group.find(params[:group_id])
    @production_unity = @group.production_unities.find(params[:production_unity_id])
  end

  def production_unity_farmer_params
    params.require(:production_unity_farmer).permit(:farmer_id)
  end

end
