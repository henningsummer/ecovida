class Groups::SetSuplentesController < ApplicationController
  before_action :set_set_suplente, only: [:show, :edit, :update, :destroy]
  before_action :set_group
  before_action only: [:create, :new] do
    require_current_or_admin(@group.core.id)
  end
  # GET /set_suplentes
  # GET /set_suplentes.json
  def index
    @set_suplentes = @group.set_suplentes.all.page(params[:page]).per(20)
  end

  # GET /set_suplentes/1
  # GET /set_suplentes/1.json
  def show
  end

  # GET /set_suplentes/new
  def new
    @set_suplente = @group.set_suplentes.build
    @set_suplente.set_type = params[:set_type] if params[:set_type].present?
  end

  # POST /set_suplentes
  # POST /set_suplentes.json
  def create
    @set_suplente = @group.set_suplentes.build(set_suplente_params)
    @set_suplente.added_by = name_and_type_of_logged_user
    respond_to do |format|
      if @set_suplente.save
        tipo = @set_suplente.set_type == 1 ? 'suplente' : 'titular'
        SystemLog.create(description: "Alterarou o #{tipo} do grupo #{@group.name}.  Novo #{tipo}: #{@set_suplente.farmer.name}", author: name_and_type_of_logged_user)
        format.html { redirect_to [@group, @set_suplente], notice: "#{@set_suplente.farmer.name} agora é #{tipo}" }
        format.json { render :show, status: :created, location: @set_suplente }
      else
        format.html { render :new }
        format.json { render json: @set_suplente.errors, status: :unprocessable_entity }
      end
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_set_suplente
    @set_suplente = SetSuplente.find(params[:id])
  end

  def set_group
    @group = Group.find_by(id: params[:group_id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def set_suplente_params
    params.require(:set_suplente).permit( :farmer_id, :set_type, :description)
  end
end
