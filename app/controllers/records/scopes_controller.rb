class Records::ScopesController < ApplicationController
  before_action :require_admin
  before_action :set_scope, only: [:show, :edit, :update, :destroy]

  # GET /scopes
  # GET /scopes.json
  def index
    @scopes = Scope.all.page(params[:page]).per(20)
  end

  # GET /scopes/1
  # GET /scopes/1.json
  def show
  end

  # GET /scopes/new
  def new
    @scope = Scope.new
  end

  # GET /scopes/1/edit
  def edit
  end

  # POST /scopes
  # POST /scopes.json
  def create
    @scope = Scope.new(scope_params)

    respond_to do |format|
      if @scope.save
        SystemLog.create(description: "Cadastrou um esocpo chamado #{@scope.name}", author: name_and_type_of_logged_user)
        format.html { redirect_to [:records, @scope], notice: 'Tipo de escopo criado com sucesso.' }
        format.json { render :show, status: :created, location: @scope }
      else
        format.html { render :new }
        format.json { render json: @scope.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /scopes/1
  # PATCH/PUT /scopes/1.json
  def update
    respond_to do |format|
      if @scope.update(scope_params)
        SystemLog.create(description: "Atualizou o escopo: #{@scope.name}", author: name_and_type_of_logged_user)
        format.html { redirect_to [:records, @scope], notice: 'Escopo atualizado com sucesso.' }
        format.json { render :show, status: :ok, location: @scope }
      else
        format.html { render :edit }
        format.json { render json: @scope.errors, status: :unprocessable_entity }
      end
    end
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_scope
      @scope = Scope.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def scope_params
      params.require(:scope).permit(:name, :acronym, :scope_type)
    end
end
