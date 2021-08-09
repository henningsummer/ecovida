class Farmers::DacsController < ApplicationController
  before_action :set_dac, only: [:show, :edit, :update, :destroy]
  before_action :set_group
  before_action :set_farmer
  before_action :require_admin, only: [:new, :create, :destroy]
  before_action :require_normal_core, only: [:show, :index]

  # GET /dacs
  # GET /dacs.json
  def index
    @dacs = @farmer.dacs.page(params[:page]).per(20)
  end

  # GET /dacs/1
  # GET /dacs/1.json
  def show
  end

  # GET /dacs/new
  def new
    @dac = @farmer.dacs.build
  end


  # POST /dacs
  # POST /dacs.json
  def create
    @dac = @farmer.dacs.build(dac_params)
    @dac.added_by = name_and_type_of_logged_user
    respond_to do |format|
      if @dac.save
        SystemLog.create(description: "Cadastraou uma nova D.A.C para o agricultor #{@farmer.name}(#{@farmer.farmer_code})", author: name_and_type_of_logged_user)
        format.html { redirect_to [@farmer.group, @farmer, @dac], notice: 'D.A.C criado com sucesso.' }
        format.json { render :show, status: :created, location: @dac }
      else
        format.html { render :new }
        format.json { render json: @dac.errors, status: :unprocessable_entity }
      end
    end
  end


  # DELETE /dacs/1
  # DELETE /dacs/1.json
  def destroy
    @dac.destroy
    SystemLog.create(description: "Deletou uma D.A.C do agricultor #{@farmer.name}(#{@farmer.farmer_code})", author: name_and_type_of_logged_user)
    respond_to do |format|
      format.html { redirect_to group_farmer_dacs_url(@farmer.group, @farmer), notice: 'D.A.C Deletado com sucesso.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_dac
      @dac = Dac.find(params[:id])
    end

    def set_group
      @group = Group.find(params[:group_id])
    end

    def set_farmer
      @farmer = @group.farmers.find(params[:farmer_id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def dac_params
      params.require(:dac).permit(:dac_date, :sampling)
    end
end
