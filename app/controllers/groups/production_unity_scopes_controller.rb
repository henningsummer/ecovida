class Groups::ProductionUnityScopesController < ApplicationController
  before_action do
    set_group
    require_current_or_admin(@group.core.id)

    set_production_unity
  end

  before_action :set_production_unity_scope, only: [:show, :edit, :update, :destroy]

  def new
    @production_unity_scope = @production_unity.production_unity_scopes.build
  end

  def show
  end

  def create
    @production_unity_scope = @production_unity.production_unity_scopes.build(production_unity_scope_params)
    if @production_unity_scope.save
      SystemLog.create(description: "Adicionou um novo escopo para #{@production_unity.name} do grupo #{@group.name}. Escopo adicionado: #{@production_unity_scope.scope.name}", author: name_and_type_of_logged_user)
      redirect_to [@group, @production_unity], notice: "Escopo adicionado com sucesso"
    else
      render :new
    end
  end

  def edit
    redirect_to [@group, @production_unity], alert: "Não é possível editar uma agro indústria" if @production_unity.scope_type == 2
  end

  def update
    SystemLog.create(description: "Atualizou o escopo #{@production_unity_scope.scope.name} da #{@production_unity.name} do grupo #{@group.name}", author: name_and_type_of_logged_user)
    if @production_unity_scope.update(production_unity_scope_params)
      redirect_to [@group, @production_unity, @production_unity_scope], notice: "Escopo atualizado com sucesso."
    else
      redirect_to [@group, @production_unity, @production_unity_scope], alert: "Não foi possível atualizar"
    end
  end

  def destroy
    @production_unity_scope.destroy

    redirect_to [@group, @production_unity], notice: 'Escopo da propriedade excluído com sucesso.'
  end

  private

  def set_production_unity_scope
    @production_unity_scope = @production_unity.production_unity_scopes.find(params[:id])
  end

  def production_unity_scope_params
    params.require(:production_unity_scope).permit(:scope_id, :total_area)
  end

  def set_group
    @group = Group.find(params[:group_id])
  end

  def set_production_unity
    @production_unity = @group.production_unities.find(params[:production_unity_id])
  end
end
