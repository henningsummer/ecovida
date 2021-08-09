class CoresController < ApplicationController
  before_action :set_core, only: [:show, :edit, :update]
  before_action :require_admin
  # GET /cores
  # GET /cores.json
  def index
    @cores = Core.order(:name).search(params[:q], params[:state]).page(params[:page]).per(20)
    @query = params[:q]
    params[:state].present? ? @state = State.find(params[:state]) : @state = nil

    respond_to do |format|
      format.html
      format.json { render json: @cores }
    end
  end

  # GET /cores/1
  # GET /cores/1.json
  def show
    @core_groups = @core.groups.order(:name).page(params[:page]).per(10)
  end

  # GET /cores/new
  def new
    @core = Core.new
  end


  def edit
  end

  # POST /cores
  # POST /cores.json
  def create
    @core = Core.new(core_params)

    respond_to do |format|
      if @core.save

        #LOG#
        SystemLog.create(description: "Criou um novo núcleo chamado #{@core.name}", author: name_and_type_of_logged_user)

        format.html { redirect_to @core, notice: "Núcleo #{@core.name} foi criado com sucesso." }
        format.json { render :show, status: :created, location: @core }
      else
        format.html { render :new }
        format.json { render json: @core.errors, status: :unprocessable_entity }
      end
    end
  end


  # PATCH/PUT /cores/1
  # PATCH/PUT /cores/1.json
  def update
    respond_to do |format|
      if @core.update(core_params)
        format.html { redirect_to @core, notice: "Nucléo #{@core.name} foi atualizado com sucesso." }
        format.json { render :show, status: :ok, location: @core }

        SystemLog.create(description: "Atualizou informações do #{@core.name}", author: name_and_type_of_logged_user) unless @core.previous_changes.empty?

      else
        format.html { render :edit }
        format.json { render json: @core.errors, status: :unprocessable_entity }
      end
    end
  end



  private
    # Use callbacks to share common setup or constraints between actions.
    def set_core
      @core = Core.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def core_params
      params.require(:core).permit(:inactive_certificate, :sig_org_access, :name, :email, :phone, :login, :password, :password_confirmation , :total_power, :state_id)
    end
end
