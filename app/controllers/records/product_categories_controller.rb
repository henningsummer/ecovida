class Records::ProductCategoriesController < ApplicationController
  before_action :require_admin
  before_action :set_product_category, only: [:show, :edit, :update, :destroy]

  # GET /records/product_categories
  # GET /records/product_categories.json
  def index
    @product_categories = ProductCategory.all.page(params[:page]).per(20)
  end

  # GET /records/product_categories/1
  # GET /records/product_categories/1.json
  def show
  end

  # GET /records/product_categories/new
  def new
    @product_category = ProductCategory.new
  end

  # GET /records/product_categories/1/edit
  def edit
  end

  # POST /records/product_categories
  # POST /records/product_categories.json
  def create
    @product_category = ProductCategory.new(product_category_params)

    respond_to do |format|
      if @product_category.save
        SystemLog.create(description: "Criada uma categoria de produto chamada #{@product_category.name}", author: name_and_type_of_logged_user)
        format.html { redirect_to [:records, @product_category], notice: 'Categoria de produto adicionada com sucesso.' }
        format.json { render :show, status: :created, location: @product_category }
      else
        format.html { render :new }
        format.json { render json: @product_category.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /records/product_categories/1
  # PATCH/PUT /records/product_categories/1.json
  def update
    respond_to do |format|
      if @product_category.update(product_category_params)
        SystemLog.create(description: "Atualizou a categoria: #{@product_category.name}", author: name_and_type_of_logged_user)
        format.html { redirect_to [:records, @product_category], notice: 'Categoria de produto atualizada com sucesso.' }
        format.json { render :show, status: :ok, location: @product_category }
      else
        format.html { render :edit }
        format.json { render json: @product_category.errors, status: :unprocessable_entity }
      end
    end
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_product_category
      @product_category = ProductCategory.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def product_category_params
      params.require(:product_category).permit(:name, :scope_id)
    end
end
