class DocumentVisualizationsController < ApplicationController
  before_action :set_document_visualization, only: [:show, :edit, :update, :destroy]
  before_action :require_admin

  # GET /document_visualizations
  # GET /document_visualizations.json
  def index
    @document_visualizations = DocumentVisualization.order_by_date.page(params[:page]).per(20)

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @document_visualizations }
    end
  end

  # GET /document_visualizations/1
  # GET /document_visualizations/1.json
  def show
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @document_visualization }
    end
  end

  # GET /document_visualizations/new
  def new
    @document_visualization = DocumentVisualization.new
  end

  # GET /document_visualizations/1/edit
  def edit
  end

  # POST /document_visualizations
  # POST /document_visualizations.json
  def create
    @document_visualization = DocumentVisualization.new(document_visualization_params)

    respond_to do |format|
      if @document_visualization.save
        format.html { redirect_to @document_visualization, notice: 'Acesso para visulização de documentos criado com sucesso.' }
        format.json { render json: @document_visualization, status: :created }
      else
        format.html { render action: 'new' }
        format.json { render json: @document_visualization.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /document_visualizations/1
  # PATCH/PUT /document_visualizations/1.json
  def update
    respond_to do |format|
      if @document_visualization.update(document_visualization_params)
        format.html { redirect_to @document_visualization, notice: 'Acesso para visulização de documentos atualizado com sucesso.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @document_visualization.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /document_visualizations/1
  # DELETE /document_visualizations/1.json
  def destroy
    @document_visualization.destroy
    respond_to do |format|
      format.html { redirect_to document_visualizations_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_document_visualization
      @document_visualization = DocumentVisualization.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def document_visualization_params
      params.require(:document_visualization).permit(:access_key, :expire_at)
    end
end
