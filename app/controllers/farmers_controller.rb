class FarmersController < ApplicationController
  before_action :group, only: [:show, :new, :edit, :index, :create, :update, :remove_suspension, :certificates, :destroy, :validate_name]
  before_action :set_farmer, only: [:show, :edit, :update, :destroy]

  respond_to :html

  before_action only: [:new, :edit, :create, :update, :certificates, :validate_name] do
    require_current_or_admin(@group.core.id)
  end
  # GET /farmers
  # GET /farmers.json
  def index
    @farmers = @group.farmers.order(name: :asc).page(params[:page]).per(10)
  end

  def validate_name
    name = params[:name]

    if name.size < 8
      render json: { valid: true }
    elsif Farmer.name_exists(name).any?
      farmer = Farmer.name_exists(name).last

      render json: { valid: false, name: farmer.name, group: farmer.group.name, core: farmer.group.core.name }
    else
      render json: { valid: true }
    end
  end

  # GET /farmers/1
  # GET /farmers/1.json
  def show
    @last_certificate = @farmer.certificate_names.joins(certificate: [:certificate_group])
                                                 .where(name_type: ["1", "2", "4"])
                                                 .order('certificate_groups.meeting_date')
                                                 .last
  end

  def certificates
    @farmer = @group.farmers.find(params[:farmer_id])
    @certificates = @farmer.certificate_names.where(name_type: ["1", "2", "4"]).order(created_at: :desc).page(params[:page]).per(20)
  end

  # GET /farmers/new
  def new
    @farmer = @group.farmers.build(number_type: 1)
  end

  # GET /farmers/1/edit
  def edit
  end

  # POST /farmers
  # POST /farmers.json
  def create
    params = user_type >= 3 ? farmer_params : farmer_params_without_super #Segurança é tudo.
    @farmer = @group.farmers.build(params)

    respond_to do |format|
      if @farmer.save
        SystemLog.create(description: "Cadastrou um agricultor chamado #{@farmer.name} no grupo #{@farmer.group.name}", author: name_and_type_of_logged_user)
        format.html { redirect_to [@farmer.group, @farmer], notice: "O #{@farmer.name} foi cadastrado(a) com sucesso." }
        format.json { render :show, status: :created, location: @farmer}
      else
        format.html { render :new }
        format.json { render json: @farmer.errors, status: :unprocessable_entity }
      end
    end
  end

  def remove_suspension
    @farmer = Farmer.find(params[:farmer_id])
    if @farmer.is_suspended?
      if @farmer.remove_suspension!
        @farmer.farmer_suspensions.last.create_sig_org_status
        SystemLog.create(description: "Removeu a suspensão de #{@farmer.name} do grupo #{@farmer.group.name}", author: name_and_type_of_logged_user)

        redirect_to [@group, @farmer], notice: 'Suspensão removida com sucesso'
      else
        redirect_to [@group, @farmer], notice: "Não foi possível remover a suspensão"
      end
    else
      redirect_to [@group, @farmer], alert: 'Este agricultor não está suspenso'
    end
  end

  def set_updated
    @farmer = Farmer.find(params[:farmer_id])
    if @farmer.sig_org_status == "Atualizado"
      redirect_to [@farmer.group, @farmer], alert: "Este agricultor já está atualizado"
    else
      @farmer.set_sig_org_updated
      SystemLog.create(description: "Atualizou #{@farmer.name} (#{@farmer.farmer_code}) no SigOrg.", author: name_and_type_of_logged_user)
      redirect_to [@farmer.group, @farmer], notice: "Agora #{@farmer.name} está atualizado no SIG.ORG"
    end
  end

  # PATCH/PUT /farmers/1
  # PATCH/PUT /farmers/1.json
  def update
    respond_to do |format|
      params = user_type >= 3 ? farmer_params : farmer_params_without_super #Segurança é tudo.
      if @farmer.update(params)

        SystemLog.create(description: "Atualizou as informações básicas do agricultor chamado #{@farmer.name} do grupo #{@farmer.group.name}", author: name_and_type_of_logged_user) unless @farmer.previous_changes.empty?

        format.html { redirect_to [@farmer.group, @farmer], notice: "O #{@farmer.name} foi atualizado(a) com sucesso." }
        format.json { render :show, status: :ok, location: @farmer }
      else
        format.html { render :edit }
        format.json { render json: @farmer.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    if FarmerService.destroy(@farmer)
      SystemLog.create(description: "Excluiu o agricultor #{@farmer.name} #{@farmer.farmer_code}", author: name_and_type_of_logged_user)
      respond_with(@farmer, location: @farmer.group)
    else
      redirect_to [@farmer.group, @farmer], alert: "O #{@farmer.name} não pode ser excluído pois é suplente ou titular do grupo."
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_farmer
    @farmer = @group.farmers.find(params[:id])
  end

  def farmer_params
    params.require(:farmer).permit(:spouse, :spouse_cpf, :em_ata, :rg,
                                   :lembrete, :number_type,
                                   :termo_compromisso, :name, :number,
                                   :address, :neighborhood, :city_id,
                                   :phone_number, :cell_phone, :email,
                                   :contract_of_adhesion, :gender, :birthday,
                                   :spouse_gender, :spouse_birthday)
  end

  def farmer_params_without_super
    params.require(:farmer).permit(:spouse, :spouse_cpf, :lembrete, :rg, :name, :number, :address, :number_type, :neighborhood, :city_id, :phone_number, :cell_phone,
                                   :email, :gender, :birthday, :spouse_gender, :spouse_birthday)
  end

  def group
    if user_type > 1 and user_type < 5 #Grupos e adms
      @group = Group.find(params[:group_id])
    elsif user_type == 1
      @group = Group.find(current_user)
    end
  end
end
