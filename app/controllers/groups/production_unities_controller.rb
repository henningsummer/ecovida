# coding: utf-8
class Groups::ProductionUnitiesController < ApplicationController
  before_action :set_user
  before_action do
    require_current_or_admin(@group.core.id)
  end

  def index
    @production_unities = @group.production_unities.all.order(name: :asc).page(params[:page]).per(20)
  end

  def show
    @production_unity = @group.production_unities.find(params[:id])
    @last_certificate = @production_unity.certificate_names.joins(certificate: [:certificate_group])
                                                           .where(name_type: 3)
                                                           .order('certificate_groups.meeting_date')
                                                           .last
  end

  def certificates
    @production_unity = @group.production_unities.find(params[:production_unity_id])
    @certificates = @production_unity.certificate_names.where(name_type: 3).page(params[:page]).per(20)
  end

  def remove_suspension
    @production_unity = @group.production_unities.find(params[:production_unity_id])
    if @production_unity.is_suspended?
      @unity_suspension = @production_unity.unity_suspensions.build(suspension_date: Date.today, suspension_type: 'Remoção da suspensão')
      @unity_suspension.save
      @unity_suspension.create_sig_org_status
      SystemLog.create(description: "Removeu a suspensão de uma unidade de produção ou agroindustria do grupo #{@group.name} chamada #{@production_unity.name}", author: name_and_type_of_logged_user)

      redirect_to [@group, @production_unity], notice: "Suspensão removida com sucesso."
    else
      redirect_to [@group, @production_unity], notice: "Está unidade não está suspensa."
    end
  end

  def set_updated
    @production_unity = ProductionUnity.find(params[:production_unity_id])
    require_current_or_admin(@production_unity.group.core.id, false, true)
    if @production_unity.sig_org_status == "Atualizado"
      redirect_to [@production_unity.group, @production_unity], alert: "Está propriedade já está atualizado"
    else
      @production_unity.set_sig_org_updated
      SystemLog.create(description: "Atualizou #{@production_unity.name} do grupo #{@production_unity.group.name} no SigOrg.", author: name_and_type_of_logged_user)
      redirect_to [@production_unity.group, @production_unity], notice: "Agora #{@production_unity.name} está atualizado no SIG.ORG"
    end
  end

  def new

    @production_unity_form = ProductionUnityForm.new
    @production_unity_form.lat_type = "S"
    @production_unity_form.lon_type = "O"
    if params[:farmer_id].present?
      farmer = @group.farmers.find(params[:farmer_id])
      @production_unity_form.farmer_id = farmer.id
      @production_unity_form.address = farmer.address
      @production_unity_form.city_id = farmer.city_id
      @production_unity_form.neighborhood = farmer.neighborhood
    end
  end

  def edit
    @production_unity = @group.production_unities.find(params[:id])
  end

  def create
    scope_type = params[:production_unity_form].permit(:scope_type).first[1]
    production_params = scope_type == "1" ? production_unity_form_params : agribusiness_form_params
    @production_unity_form = ProductionUnityForm.new(production_params)
    @production_unity_form.group_id = @group.id
    @production_unity_form.scopes = params.require(:scopes) if not params[:scopes].nil?

    if @production_unity_form.save!
      SystemLog.create(description: "Criou uma unidade de produção ou agroindustria para o grupo #{@group.name} chamada #{@production_unity_form.name}", author: name_and_type_of_logged_user)
      redirect_to(group_production_unity_path(@group, @production_unity_form.production_unity_to_read), notice: "Unidade de produção criada com sucesso.")
    else
      render :new
    end
  end

  def update
    @production_unity = @group.production_unities.find(params[:id])
    production_params = @production_unity.scope_type == 1 ? edit_production_unity_params : edit_agribusiness_params
    if @production_unity.update(production_params)
      SystemLog.create(description: "Atualizou as informações básicas de uma unidade de produção ou agroindustria para o grupo #{@group.name} chamada #{@production_unity.name}", author: name_and_type_of_logged_user)
      redirect_to [@group, @production_unity], notice: "Edições realizadas com sucesso."
    else
      render :edit
    end

  end

  def destroy
    @production_unity = @group.production_unities.find(params[:id])
    @production_unity.excluded = true
    @production_unity.save(validate: false)

    SystemLog.create(description: "Excluiu uma propriedade do #{@group.name} chamada #{@production_unity.name}", author: name_and_type_of_logged_user)

    redirect_to group_path(@group), notice: 'Propriedade foi excluída com sucesso'
  end

  private

  def set_user
    @group = Group.find(params[:group_id])
  end

  def edit_production_unity_params
    params.require(:production_unity).permit(:lat_hour, :lat_minute, :lat_second, :lat_type, :lon_hour, :lon_minute, :lon_second, :lon_type, :cep, :name, :production_type, :address, :neighborhood, :city_id, :geographic_coordinates, :total_area, :total_organic_area, :total_native_area)
  end

  def edit_agribusiness_params

    params.require(:production_unity).permit(:register_type, :cep, :name, :production_type, :address, :neighborhood, :city_id, :fantasy_name, :number_type, :number_type, :register_number, :register_number, :phone, :email, :number)

  end

  def production_unity_form_params
    params.require(:production_unity_form).permit(
      :name, :address, :neighborhood, :city_id, :cep, :group_id, :farmer_id, :scope_type, :geographic_coordinates, :total_area, :total_native_area, :total_organic_area, :production_type,
      :lat_hour, :lat_minute, :lat_second, :lat_type, :lon_hour, :lon_minute, :lon_second, :lon_type)
  end

  def agribusiness_form_params
    params.require(:production_unity_form).permit(
      :name, :number, :number_type, :fantasy_name, :cep, :register_type, :register_number,
      :address, :neighborhood, :city_id, :group_id, :farmer_id, :scope_type, :production_type, :phone, :email)
  end

end
