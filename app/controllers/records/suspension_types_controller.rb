class Records::SuspensionTypesController < ApplicationController
  before_action :require_admin
  before_action :set_suspension_type, only: [:show, :edit, :update, :destroy]

  # GET /suspension_types
  # GET /suspension_types.json
  def index
    @suspension_types = SuspensionType.all.page(params[:page]).per(20)
  end

  # GET /suspension_types/1
  # GET /suspension_types/1.json
  def show
  end

  # GET /suspension_types/new
  def new
    @suspension_type = SuspensionType.new
  end

  # GET /suspension_types/1/edit
  def edit
  end

  # POST /suspension_types
  # POST /suspension_types.json
  def create
    @suspension_type = SuspensionType.new(suspension_type_params)

    respond_to do |format|
      if @suspension_type.save
        SystemLog.create(description: "Cadastrou um novo tipo de suspensão de agricultor chamado #{@suspension_type.name}", author: name_and_type_of_logged_user)

        format.html { redirect_to [:records, @suspension_type], notice: 'Tipo de suspensão criado com sucesso.' }
        format.json { render :show, status: :created, location: @suspension_type }
      else
        format.html { render :new }
        format.json { render json: @suspension_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /suspension_types/1
  # PATCH/PUT /suspension_types/1.json
  def update
    respond_to do |format|
      if @suspension_type.update(suspension_type_params)
        SystemLog.create(description: "Atualizou o tipo de suspensão: #{@suspension_type.name}", author: name_and_type_of_logged_user)


        format.html { redirect_to [:records, @suspension_type], notice: 'Tipo de suspensão atualizado com sucesso.' }
        format.json { render :show, status: :ok, location: @suspension_type }
      else
        format.html { render :edit }
        format.json { render json: @suspension_type.errors, status: :unprocessable_entity }
      end
    end
  end



  private
    # Use callbacks to share common setup or constraints between actions.
    def set_suspension_type
      @suspension_type = SuspensionType.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def suspension_type_params
      params.require(:suspension_type).permit(:name)
    end
end
