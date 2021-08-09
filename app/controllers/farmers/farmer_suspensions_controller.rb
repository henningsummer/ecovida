class Farmers::FarmerSuspensionsController < ApplicationController

  before_action do
    set_group
    require_current_or_admin(@group.core.id)
    set_farmer
  end
  before_action only: [:new, :create] do
    require_admin
    if @farmer.is_suspended?
      redirect_to [@group, @farmer], alert: "Impossível suspender quem já está suspenso."
    end
  end
  before_action only: [:edit, :update] do
    require_admin
  end
  before_action :set_farmer_suspension, only: [:show, :edit, :update, :destroy]

  # GET /farmer_suspensions
  # GET /farmer_suspensions.json
  def index
    @farmer_suspensions = @farmer.farmer_suspensions.page(params[:page]).per(20)
  end



  # GET /farmer_suspensions/1
  # GET /farmer_suspensions/1.json
  def show
  end

  # GET /farmer_suspensions/new
  def new
    @farmer_suspension = @farmer.farmer_suspensions.build
  end

  # GET /farmer_suspensions/1/edit
  def edit
  end

  # POST /farmer_suspensions
  # POST /farmer_suspensions.json
  def create
    @farmer_suspension = @farmer.farmer_suspensions.build(farmer_suspension_params)

    respond_to do |format|
      if @farmer_suspension.save
        @farmer_suspension.update_suspension_reasons(params[:suspension_types])
        @farmer_suspension.create_sig_org_status
        SystemLog.create(description: "Suspendeu #{@farmer.name}(#{@farmer.farmer_code}", author: name_and_type_of_logged_user)
        format.html { redirect_to [@group, @farmer], notice: "#{@farmer.name} foi suspenso com sucesso." }
        format.json { render :show, status: :created, location: @farmer_suspension }
      else
        format.html { render :new }
        format.json { render json: @farmer_suspension.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /farmer_suspensions/1
  # PATCH/PUT /farmer_suspensions/1.json
  def update
    respond_to do |format|
      if @farmer_suspension.update(farmer_suspension_params)
        @farmer_suspension.update_suspension_reasons(params[:suspension_types])
        @farmer_suspension.create_sig_org_status(true) #é update, então, true
        SystemLog.create(description: "Atualizou as informações da suspensão de #{@farmer.name}(#{@farmer.farmer_code} da data: #{@farmer_suspension.suspension_date.strftime("%d/%m/%Y")
}", author: name_and_type_of_logged_user)
        format.html { redirect_to [@group, @farmer, @farmer_suspension], notice: "Suspensão de #{@farmer.name} foi atualizada com sucesso" }
        format.json { render :show, status: :ok, location: @farmer_suspension }
      else
        format.html { render :edit }
        format.json { render json: @farmer_suspension.errors, status: :unprocessable_entity }
      end
    end
  end


  private

    def set_group
      @group = Group.find(params[:group_id])
    end

    def set_farmer
      @farmer = @group.farmers.find(params[:farmer_id])
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_farmer_suspension
      @farmer_suspension = @farmer.farmer_suspensions.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def farmer_suspension_params
      params.require(:farmer_suspension).permit(:description, :suspension_date)
    end
end
