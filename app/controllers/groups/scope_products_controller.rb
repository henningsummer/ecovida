class Groups::ScopeProductsController < ApplicationController
  before_action :set_scope_product, only: [:show, :edit, :update, :destroy]
  before_action do
    set_group
    require_current_or_admin(@group.core.id)

    set_production_unity
    set_production_unity_scope
  end



  def show
  end

  # GET /scope_products/new
  def new
    set_categories
    @scope_product = @production_unity_scope.scope_products.build

  end

  # GET /scope_products/1/edit
  def edit
  end

  # POST /scope_products
  # POST /scope_products.json
  def create

    if(@production_unity.scope_type == 1)
      @scope_product = @production_unity_scope.scope_products.build(scope_product_production_unity_params)
    else
      @scope_product = @production_unity_scope.scope_products.build(scope_product_agribusiness_params)
    end

    to_redirect = params[:commit] == 'Salvar produto' ? new_group_production_unity_production_unity_scope_scope_product_url(@group, @production_unity, @production_unity_scope) : [@group, @production_unity, @production_unity_scope]

    respond_to do |format|
      if @scope_product.save
        SystemLog.create(description: "Cadastrou um novo produto para #{@production_unity.name} chamado #{@scope_product.product.name}", author: name_and_type_of_logged_user)
        format.html { redirect_to to_redirect, notice: 'Produto adicionado com sucesso.' }
        format.json { render :show, status: :created, location: @scope_product }
      else

        set_categories
        format.html { render :new, category: params[:category] }
        format.json { render json: @scope_product.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /scope_products/1
  # PATCH/PUT /scope_products/1.json
  def update
    # Se for unidade de produção, é 1, se não, é outro
    @production_unity.scope_type == 1 ? params = scope_product_production_unity_params : params = scope_product_agribusiness_params
    respond_to do |format|
      if @scope_product.update(params)
        SystemLog.create(description: "Atualizou um produto da unidade de produção: #{@production_unity.name} chamado #{@scope_product.product.name}", author: name_and_type_of_logged_user)
        format.html { redirect_to [@group, @production_unity, @production_unity_scope], notice: 'Produto atualizado com sucesso.' }
        format.json { render :show, status: :ok, location: @scope_product }
      else
        format.html { render :edit }
        format.json { render json: @scope_product.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /scope_products/1
  # DELETE /scope_products/1.json
  def destroy
    @scope_product.destroy
    SystemLog.create(description: "Deletou um produto da unidade de produção: #{@production_unity.name} chamado #{@scope_product.product.name}", author: name_and_type_of_logged_user)

    respond_to do |format|
      format.html { redirect_to [@group, @production_unity, @production_unity_scope], notice: 'Produto removido com sucesso.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_scope_product
      @scope_product = ScopeProduct.find(params[:id])
    end


    def set_group
      @group = Group.find(params[:group_id])
    end

    def set_production_unity
      @production_unity = @group.production_unities.find(params[:production_unity_id])
    end

    def set_categories
      text = params[:category].nil? ? "" : ["Categoria selecionada: #{ProductCategory.find(params[:category]).name}", params[:category]]
      @categories = [text]
      @categories += @production_unity_scope.scope.product_categories.all.collect {|c| [c.name, c.id]}
      @products = @production_unity_scope.scope.product_categories.find(params[:category]).products.order(:name) if not params[:category].nil?
    end

    def set_production_unity_scope
      @production_unity_scope = @production_unity.production_unity_scopes.find(params[:production_unity_scope_id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def scope_product_production_unity_params
      params.require(:scope_product).permit(:area, :group, :unity, :amount, :product_id)
    end
    def scope_product_agribusiness_params
      params.require(:scope_product).permit(:is_processor, :package_size, :package_size_unity, :amount_per_year_unity, :amount_per_year, :product_id)
    end
end
