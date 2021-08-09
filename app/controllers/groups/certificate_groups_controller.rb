class Groups::CertificateGroupsController < ApplicationController
  before_action :set_group
  before_action :set_certificate_group, only: [:show, :edit]
  before_action do
    require_current_or_admin(@group.core.id)
    redirect_to root_path, notice: 'Área restrita' unless can_generate_certificate?
  end

  # GET /certificate_groups
  # GET /certificate_groups.json
  def index
    @certificate_groups = @group.certificate_groups.order(created_at: :desc).page(params[:page]).per(20)
  end

  # GET /certificate_groups/1
  # GET /certificate_groups/1.json
  def show
  end

  # GET /certificate_groups/new
  def new
    @group_analysis = Certification.verify_and_list(@group)
    @certificate_group = @group.certificate_groups.build
  end

  # GET /certificate_groups/1/edit
  def edit
  end

  # POST /certificate_groups
  # POST /certificate_groups.json
  def create
    @group_analysis = Certification.verify_and_list(@group)
    @certificate_group = @group.certificate_groups.build(certificate_group_params)
    @certificate_group.farmers = params[:farmers].present? ? params[:farmers] : []
    @certificate_group.agribusiness = params[:agribusiness].present? ? params[:agribusiness] : []
    respond_to do |format|
      if @certificate_group.save
        SystemLog.create(description: "Gerou certificados para o grupo #{@group.name}", author: name_and_type_of_logged_user)

        format.html { redirect_to [@group, @certificate_group], notice: 'Certificados do grupo criado com sucesso.' }
        format.json { render :show, status: :created, location: @certificate_group }
      else
        format.html { render :new }
        format.json { render json: @certificate_group.errors, status: :unprocessable_entity }
      end
    end
  end


  private
  
  def set_group
    @group = Group.find(params[:group_id])
  end
  # Use callbacks to share common setup or constraints between actions.
  def set_certificate_group
    @certificate_group = CertificateGroup.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def certificate_group_params
    params.require(:certificate_group).permit(:meeting_number, :meeting_page, :meeting_date, :group_id, :city_id)
  end
end
