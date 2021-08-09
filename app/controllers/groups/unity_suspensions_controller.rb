class Groups::UnitySuspensionsController < ApplicationController
  before_action do
    set_group
    set_production_unity
  end

  before_action only: [:update, :edit] do
    require_admin
  end

  before_action only: [:new, :create] do
    require_admin
    if @production_unity.is_suspended?
      redirect_to [@group, @production_unity], alert: "Impossível suspender está propriedade. Já está suspensa."
    end
  end

  before_action :set_unity_suspension, only: [:show, :edit, :update, :destroy]

  # GET /unity_suspensions
  # GET /unity_suspensions.json
  def index
    @unity_suspensions = @production_unity.unity_suspensions.page(params[:page]).per(20)
  end

  # GET /unity_suspensions/1
  # GET /unity_suspensions/1.json
  def show
  end

  # GET /unity_suspensions/new
  def new
    @unity_suspension = @production_unity.unity_suspensions.build
  end

  # GET /unity_suspensions/1/edit
  def edit
    redirect_to [@group, @production_unity], alert: 'Impossível editar.' if @unity_suspension.suspension_type != 'Suspensão'
  end

  # POST /unity_suspensions
  # POST /unity_suspensions.json
  def create
    @unity_suspension = @production_unity.unity_suspensions.build(unity_suspension_params)

    respond_to do |format|
      if @unity_suspension.save
        @unity_suspension.update_suspension_reasons(params[:suspension_types])
        @unity_suspension.create_sig_org_status
        SystemLog.create(description: "Suspendeu #{@production_unity.name} do grupo #{@group.name}", author: name_and_type_of_logged_user)
        format.html { redirect_to [@group, @production_unity], notice: 'A Unidade de produção foi suspensa com sucesso.' }
        format.json { render :show, status: :created, location: @unity_suspension }
      else
        format.html { render :new }
        format.json { render json: @unity_suspension.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /unity_suspensions/1
  # PATCH/PUT /unity_suspensions/1.json
  def update
    respond_to do |format|
      if @unity_suspension.update(unity_suspension_params)
        @unity_suspension.update_suspension_reasons(params[:suspension_types])
        @unity_suspension.create_sig_org_status(true)
        SystemLog.create(description: "Atualizou a suspensão de #{@production_unity.name} do grupo #{@group.name} da data: #{@unity_suspension.suspension_date.strftime("%d/%m/%Y")
}", author: name_and_type_of_logged_user)
        format.html { redirect_to [@group, @production_unity, @unity_suspension], notice: 'A suspensão da unidade de produção foi atualizada com sucesso.' }
        format.json { render :show, status: :ok, location: @unity_suspension }
      else
        format.html { render :edit }
        format.json { render json: @unity_suspension.errors, status: :unprocessable_entity }
      end
    end
  end

  private

  def set_group
    @group = Group.find(params[:group_id])
  end

  def set_production_unity
    @production_unity = @group.production_unities.find(params[:production_unity_id])
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_unity_suspension
    @unity_suspension = @production_unity.unity_suspensions.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def unity_suspension_params
    params.require(:unity_suspension).permit(:description, :suspension_date, :production_unity_id)
  end
end
