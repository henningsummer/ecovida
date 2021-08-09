class Records::ProductsController < ApplicationController
  before_action :require_admin
  before_action :set_records_product, only: [:show, :edit, :update, :destroy]


  def index
    @q = Product.ransack(params[:q])
    @records_products = @q.result.page(params[:page])
  end


  def show
  end


  def new
    @records_product = Product.new
  end


  def edit
  end


  def create
    @records_product = Product.new(records_product_params)
    respond_to do |format|

      if @records_product.save
        SystemLog.create(description: "Cadastou um produto chamado #{@records_product.name}", author: name_and_type_of_logged_user)

        redirect_path = params[:commit] == "Salvar e voltar" ? records_products_url : new_records_product_url
        format.html { redirect_to redirect_path, notice: 'Produto criado com sucesso.' }
        format.json { render :show, status: :created, location: @records_product }
      else
        format.html { render :new }
        format.json { render json: [:records, @records_product.errors], status: :unprocessable_entity }
      end

    end
  end

  def update
    respond_to do |format|

        if @records_product.update(records_product_params)
          SystemLog.create(description: "Atualizou o produto: #{@records_product.name}", author: name_and_type_of_logged_user)

          format.html { redirect_to [:records, @records_product], notice: 'Produto foi atualizado com sucesso.' }
          format.json { render :show, status: :ok, location: @records_product }
        else
          format.html { render :edit }
          format.json { render json: @records_product.errors, status: :unprocessable_entity }
        end

    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_records_product
      @records_product = Product.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def records_product_params
      params.require(:product).permit(:name, :product_category_id)
    end
end
