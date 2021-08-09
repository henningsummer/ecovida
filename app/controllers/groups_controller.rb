class GroupsController < ApplicationController
  before_action :set_group, only: [:show, :edit, :update, :destroy]
  before_action :require_normal_core, only: [:show, :index, :new, :create]
  before_action :require_admin, only: [:destroy, :group_dacs]

  before_action only: [:group_dacs, :create_group_dacs] do
    @group = Group.find(params[:group_id])
    if (@group.present?)
      require_current_or_admin(@group.core.id)
      if user_type < 3
        redirect_to root_path, alert: "Você não pode cadastrar D.A.C's"
      end

    end
  end

  before_action only: [:edit, :update] do
    # Verifica se o nucleo é quem pode editar ou deletar

    if(@group.present?)
      require_current_or_admin(@group.core.id)
    end
  end

  before_action only: [:outdateds, :update_outdateds] do #Apenas quem tem acesso
    @group = Group.find(params[:group_id])
    require_current_or_admin(@group.core.id, false, true)
  end


  # GET /groups
  # GET /groups.json
  def index
    @query = params[:q]
    @state = params[:state]
    @not_updated = params[:only_not_updateds]
    if @query.present? or @state.present? or @not_updated == "1"
      @groups = Group.search(params[:q], params[:state], params[:only_not_updateds], user_type, current_user)
                     .page(params[:page]).per(20)
      @state = params[:state].present? ? State.find(params[:state]) : nil
    else
      if user_type == 4 #Se é administrador
        @groups = Group.all.page(params[:page]).per(20)
      else
        @groups = Core.find(current_user).groups.page(params[:page]).per(20)
      end
    end
    @groups = @groups.order(name: :asc)
  end

  def outdateds
    @outdateds = @group.outdateds
    @not_added = @group.not_added_in_sigorg
  end

  def update_outdateds
    farmers = []
    production_unities = []
    farmers = params[:farmer] if not params[:farmer].nil?
    production_unities = params[:unity] if not params[:unity].nil?
    @group.user_and_type_of_logged_user = name_and_type_of_logged_user
    if @group.update_outdateds(farmers, production_unities)
      redirect_to @group, notice: "Os selecionados foram marcados como atualizados com sucesso."
    else
      redirect_to @group, alert: "Alguma coisa de errada aconteceu.  Verifique se as atualizações foram concluídas.  Se não, entre em contato com o programador."
    end

  end

  # GET /groups/1/group_dacs

  def group_dacs
    @group = Group.find(params[:group_id])
    @group_dac = GroupDac.new
  end

  def create_group_dacs
    @group = Group.find(params[:group_id])
    @group_dac = GroupDac.new
    @group_dac.farmers = params[:farmers]
    @group_dac.data_dac = params[:group_dac]
    @group_dac.author = name_and_type_of_logged_user
    @group_dac.group = @group

    if @group_dac.save!
      SystemLog.create(description: "Cadastro DACs para o grupo #{@group.name}", author: name_and_type_of_logged_user)
      redirect_to @group, notice: "DAC's cadastradas com sucesso"
    else
      render :group_dacs
    end
  end

  # GET /groups/1
  # GET /groups/1.json
  def show
  end

  # GET /groups/new
  def new
    if user_type == 4 #Se é administrador
      @group = Group.new
      @group.core_id = params[:core] if params[:core].present?
    else
      @group = Core.find(current_user).groups.build
    end
  end

  # GET /groups/1/edit
  def edit
  end

  def destroy
    GroupService.new(@group).destroy

    SystemLog.create(description: "Excluiu o grupo #{@group.name}", author: name_and_type_of_logged_user)

    respond_with(@group, location: groups_path)
  end

  # POST /groups
  # POST /groups.json
  def create
    if(user_type == 4)
      @group = Group.new(group_params)
    else
      @group = Core.find(current_user).groups.build(core_group_params)
    end
    respond_to do |format|
      if @group.save
        SystemLog.create(description: "Criou um novo grupo chamado #{@group.name} para o núcleo #{@group.core.name}", author: name_and_type_of_logged_user)
        format.html { redirect_to @group, notice: 'Grupo criado com sucesso.' }
        format.json { render :show, status: :created, location: @group }
      else
        format.html { render :new }
        format.json { render json: @group.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /groups/1
  # PATCH/PUT /groups/1.json
  def update
    respond_to do |format|
      params = user_type == 4 ? group_params : core_group_params
      if @group.update(params)
        SystemLog.create(description: "Atualizou informações básicas do grupo chamado #{@group.name} do núcleo #{@group.core.name}", author: name_and_type_of_logged_user) unless @group.previous_changes.empty?

        format.html { redirect_to @group, notice: 'Grupo atualizado com sucesso.' }
        format.json { render :show, status: :ok, location: @group }
      else
        format.html { render :edit }
        format.json { render json: @group.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /groups/1
  # DELETE /groups/1.json


  private
  # Use callbacks to share common setup or constraints between actions.
  def set_group
    @group = Group.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def group_params
    params.require(:group).permit(:name, :phone, :email, :core_id, :login, :group_type_id, :password, :password_confirmation)
  end

  def core_group_params #Segurança é tudo (retirei o core_id)
    params.require(:group).permit(:name, :phone, :email, :group_type_id, :login, :password, :password_confirmation)
  end
end
