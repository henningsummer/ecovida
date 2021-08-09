class Records::GroupTypesController < ApplicationController
  before_action :require_admin
  before_action :set_group_type, only: [:show, :edit, :update, :destroy]

  # GET /group_types
  # GET /group_types.json
  def index
    @group_types = GroupType.all.page().per(10)
  end

  # GET /group_types/1
  # GET /group_types/1.json
  def show
  end

  # GET /group_types/new
  def new
    @group_type = GroupType.new
  end

  # GET /group_types/1/edit
  def edit
  end

  # POST /group_types
  # POST /group_types.json
  def create
    @group_type = GroupType.new(group_type_params)

    respond_to do |format|
      if @group_type.save
        SystemLog.create(description: "Criou um tipo de grupo chamado #{@group_type.description}", author: name_and_type_of_logged_user)
        format.html { redirect_to [:records, @group_type], notice: 'Tipo de grupo criado com sucesso.' }
        format.json { render :show, status: :created, location: @group_type }
      else
        format.html { render :new }
        format.json { render json: @group_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /group_types/1
  # PATCH/PUT /group_types/1.json
  def update
    respond_to do |format|
      old_name = @group_type.description
      if @group_type.update(group_type_params)
        SystemLog.create(description: "Atualizou o tipo de grupo #{old_name} para #{@group_type.description}", author: name_and_type_of_logged_user)
        format.html { redirect_to [:records, @group_type], notice: 'Tipo de grupo atualizado com sucesso.' }
        format.json { render :show, status: :ok, location: @group_type }
      else
        format.html { render :edit }
        format.json { render json: @group_type.errors, status: :unprocessable_entity }
      end
    end
  end



  private
    # Use callbacks to share common setup or constraints between actions.
    def set_group_type
      @group_type = GroupType.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def group_type_params
      params.require(:group_type).permit(:description)
    end
end
