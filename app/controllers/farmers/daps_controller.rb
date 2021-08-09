class Farmers::DapsController < ApplicationController
  before_action :set_dap, only: [:show, :edit, :update, :destroy]
  before_action :set_group
  before_action :set_farmer
  before_action only: [:new, :create, :destroy] do
    #Necessita ser dono,
    require_current_or_admin(@farmer.group.core.id, false, false)

  end
  before_action :require_normal_core, only: [:show, :index]
  # GET /daps
  # GET /daps.json
  def index
    @daps = @farmer.daps.page(params[:page]).per(20)
  end

  # GET /daps/1
  # GET /daps/1.json
  def show
  end

  # GET /daps/new
  def new
    @dap = @farmer.daps.build
  end


  # POST /daps
  # POST /daps.json
  def create
    @dap = @farmer.daps.build(dap_params)
    @dap.added_by = name_and_type_of_logged_user
    respond_to do |format|
      if @dap.save
        SystemLog.create(description: "Cadastraou uma nova D.A.P para o agricultor #{@farmer.name}(#{@farmer.farmer_code}) com o numero #{@dap.dap_number}", author: name_and_type_of_logged_user)
        format.html { redirect_to [@farmer.group, @farmer, @dap], notice: 'D.A.P criado com sucesso.' }
        format.json { render :show, status: :created, location: @dap }
      else
        format.html { render :new }
        format.json { render json: @dap.errors, status: :unprocessable_entity }
      end
    end
  end


  # DELETE /daps/1
  # DELETE /daps/1.json
  def destroy
    @dap.destroy
    SystemLog.create(description: "Deletou um DAP do agricultor #{@farmer.name}(#{@farmer.farmer_code}) com o numero #{@dap.dap_number}", author: name_and_type_of_logged_user)
    respond_to do |format|
      format.html { redirect_to group_farmer_daps_url(@farmer.group, @farmer), notice: 'D.A.P Deletado com sucesso.' }
      format.json { head :no_content }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_dap
    @dap = Dap.find(params[:id])
  end

  def set_group
    @group = Group.find(params[:group_id])
  end

  def set_farmer
    @farmer = @group.farmers.find(params[:farmer_id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def dap_params
    params.require(:dap).permit(:dap_number, :validity, :emission_date)
  end
end
