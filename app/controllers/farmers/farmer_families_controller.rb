class Farmers::FarmerFamiliesController < ApplicationController
  before_action :set_farmer_family, only: [:show, :edit, :update, :destroy]
  before_action :set_farmer
  before_action :set_group

  before_action :require_normal_core
  before_action only: [:new, :edit, :create, :update, :destroy] do
    require_current_or_admin(@group.core.id)
  end


  # GET /farmer_families
  # GET /farmer_families.json
  def index
    @farmer_families = @farmer.farmer_families
  end

  # GET /farmer_families/1
  # GET /farmer_families/1.json
  def show
  end

  # GET /farmer_families/new
  def new
    @farmer_family = @farmer.farmer_families.build
  end

  # GET /farmer_families/1/edit
  def edit
  end

  # POST /farmer_families
  # POST /farmer_families.json
  def create
    @farmer_family = @farmer.farmer_families.build(farmer_family_params)

    respond_to do |format|
      if @farmer_family.save
        SystemLog.create(description: "Cadastraou uma novo membro da família para o agricultor #{@farmer.name}(#{@farmer.farmer_code}) chamado #{@farmer_family.name}", author: name_and_type_of_logged_user)
        format.html { redirect_to [@group, @farmer_family.farmer, @farmer_family], notice: 'Integrante da familia adicionado com sucesso' }
        format.json { render :show, status: :created, location: @farmer_family }
      else
        format.html { render :new }
        format.json { render json: @farmer_family.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /farmer_families/1
  # PATCH/PUT /farmer_families/1.json
  def update
    respond_to do |format|
      if @farmer_family.update(farmer_family_params)
        SystemLog.create(description: "Atualizou as informações do membro da família do agricultor #{@farmer.name}(#{@farmer.farmer_code}) chamado #{@farmer_family.name}", author: name_and_type_of_logged_user)
        format.html { redirect_to [@group, @farmer_family.farmer, @farmer_family], notice: 'Integrante da familia atualizado com sucesso.' }
        format.json { render :show, status: :ok, location: @farmer_family }
      else
        format.html { render :edit }
        format.json { render json: @farmer_family.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
   if @farmer_family.destroy
    SystemLog.create(description: "deletou um membro da família do agricultor #{@farmer.name}(#{@farmer.farmer_code}) chamado #{@farmer_family.name}", author: name_and_type_of_logged_user)
    redirect_to group_farmer_farmer_families_url(@group, @farmer), notice: "Membro da fámilia removido com sucesso"
   else
    redirect_to [@group, @farmer, @farmer_family], alert: "Não foi possível deletar o membro da fámilia"
   end
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_farmer_family
      @farmer_family = FarmerFamily.find(params[:id])
    end

    def set_group
      @group = Group.find(params[:group_id])
    end

    def set_farmer
      @farmer = Farmer.find(params[:farmer_id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def farmer_family_params
      params.require(:farmer_family).permit(:name, :cpf, :farmer_id, :gender, :birthday)
    end


end
