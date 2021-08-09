class Cores::CoreCoordinatorsController < ApplicationController
  before_action :set_core
  before_action :set_core_coordinator, only: [:show, :edit, :update, :destroy, :update_current]
  before_action only: [:new, :create, :edit, :update, :index, :update_current] do
    require_current_or_admin(@core.id)
  end

  # GET /:core_id/core_coordinators
  # GET /:core_id/core_coordinators.json
  def index
    @core_coordinators = @core.core_coordinators.order(:name).all.page(params[:page]).per(20)
  end

  # GET /core_coordinators/new
  def new
    @core_coordinator = @core.core_coordinators.build
  end

  # GET /core_coordinators/1/edit
  def edit
  end

  # POST /core_coordinators
  # POST /core_coordinators.json
  def create
    @core_coordinator = @core.core_coordinators.build(core_coordinator_params.merge(current: true))

    respond_to do |format|
      if @core_coordinator.save
        @core.core_coordinators.where.not(id: @core_coordinator.id).update_all(current: false)

        SystemLog.create(description: "Cadastraou um novo coordenador para o núcleo #{@core.name} chamado #{@core_coordinator.name}", author: name_and_type_of_logged_user)
        format.html { redirect_to core_core_coordinators_path(@core), notice: "#{@core_coordinator.name} é o novo coordenador." }
        format.json { render :show, status: :created, location: @core_coordinator }
      else
        format.html { render :new }
        format.json { render json: @core_coordinator.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /core_coordinators/1
  # PATCH/PUT /core_coordinators/1.json
  def update
    respond_to do |format|
      if @core_coordinator.update(core_coordinator_params)
        SystemLog.create(description: "Editou um coordenador do núcleo #{@core.name} chamado #{@core_coordinator.name}", author: name_and_type_of_logged_user)
        format.html { redirect_to core_core_coordinators_path(@core), notice: "#{@core_coordinator.name} foi atualizado com sucesso." }
        format.json { render :show, status: :ok, location: @core_coordinator }
      else
        format.html { render :edit }
        format.json { render json: @core_coordinator.errors, status: :unprocessable_entity }
      end
    end
  end

  def update_current
    @core.core_coordinators.update_all(current: false)

    if @core_coordinator.update(current: true)
      flash[:notice] = 'Coordenador atualizado com sucesso.'
    else
      flash[:alert] = 'Não foi possível atualizar o coordenador'
    end

    redirect_to [@core, :core_coordinators]
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_core_coordinator
      @core_coordinator = CoreCoordinator.find(params[:id])
    end

    def set_core
      @core = Core.find(params[:core_id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def core_coordinator_params
      params.require(:core_coordinator).permit(:name, :email, :phone)
    end
end
