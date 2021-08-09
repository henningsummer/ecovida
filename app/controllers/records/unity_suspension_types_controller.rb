class Records::UnitySuspensionTypesController < ApplicationController
  before_action :require_admin
  before_action :set_unity_suspension_type, only: [:show, :edit, :update, :destroy]

  # GET /unity_suspension_types
  # GET /unity_suspension_types.json
  def index
    @unity_suspension_types = UnitySuspensionType.all
  end

  # GET /unity_suspension_types/1
  # GET /unity_suspension_types/1.json
  def show
  end

  # GET /unity_suspension_types/new
  def new
    @unity_suspension_type = UnitySuspensionType.new
  end

  # GET /unity_suspension_types/1/edit
  def edit
  end

  # POST /unity_suspension_types
  # POST /unity_suspension_types.json
  def create
    @unity_suspension_type = UnitySuspensionType.new(unity_suspension_type_params)

    respond_to do |format|
      if @unity_suspension_type.save
        SystemLog.create(description: "Cadastrou um novo tipo de suspensão de propriedade chamado #{@unity_suspension_type.name}", author: name_and_type_of_logged_user)


        format.html { redirect_to [:records, @unity_suspension_type], notice: 'Tipo de suspensão criado com sucesso.' }
        format.json { render :show, status: :created, location: @unity_suspension_type }
      else
        format.html { render :new }
        format.json { render json: @unity_suspension_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /unity_suspension_types/1
  # PATCH/PUT /unity_suspension_types/1.json
  def update
    respond_to do |format|
      if @unity_suspension_type.update(unity_suspension_type_params)
        SystemLog.create(description: "Atualizou o tipo de suspensão de propriedade chamado #{@unity_suspension_type.name}", author: name_and_type_of_logged_user)

        format.html { redirect_to [:records, @unity_suspension_type], notice: 'Tipo de suspensão atualizado com sucesso.' }
        format.json { render :show, status: :ok, location: @unity_suspension_type }
      else
        format.html { render :edit }
        format.json { render json: @unity_suspension_type.errors, status: :unprocessable_entity }
      end
    end
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_unity_suspension_type
      @unity_suspension_type = UnitySuspensionType.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def unity_suspension_type_params
      params.require(:unity_suspension_type).permit(:name)
    end
end
