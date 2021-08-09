class Farmers::FarmerGroupChangesController < ApplicationController

  before_action do
    set_group
    set_farmer
    require_current_or_admin(@group.core.id, false, false)
  end

  # GET /farmer_group_changes
  # GET /farmer_group_changes.json
  def index
    @farmer_group_changes = @farmer.farmer_group_changes.all.page(params[:page]).per(20)
  end


  # GET /farmer_group_changes/new
  def new
    @farmer_group_change = @farmer.farmer_group_changes.build
  end


  # POST /farmer_group_changes
  # POST /farmer_group_changes.json
  def create
    @farmer_group_change = @farmer.farmer_group_changes.build(farmer_group_change_params)

    respond_to do |format|
      if @farmer_group_change.save
        SystemLog.create(description: "Trocou o agricultor #{@farmer_group_change.farmer.name} para o grupo #{@farmer_group_change.group.name}", author: name_and_type_of_logged_user)
        format.html { redirect_to [@farmer_group_change.group, @farmer_group_change.farmer], notice: 'Agricultor agora pertence há um novo grupo !.' }
        format.json { render :show, status: :created, location: @farmer_group_change }
      else
        format.html { render :new }
        format.json { render json: @farmer_group_change.errors, status: :unprocessable_entity }
      end
    end
  end



  private
  # Use callbacks to share common setup or constraints between actions.
  def set_group
    @group = Group.find(params[:group_id])
  end

  def set_farmer
    @farmer = @group.farmers.find(params[:farmer_id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def farmer_group_change_params
    params.require(:farmer_group_change).permit(:farmer_id, :group_id)
  end
end
