class Records::DocumentsController < ApplicationController
  before_action :set_document, only: [:show, :edit, :update, :destroy]
  before_action :require_admin

  def index
    @documents = Document.all.order(:name).page().per(10)

    respond_to do |format|
      format.html # index.html.erb
    end
  end

  def show
  end

  def new
    @document = Document.new
  end

  def edit
  end

  def create
    @document = Document.new(document_params)

    respond_to do |format|
      if @document.save
        format.html { redirect_to records_documents_path, notice: 'Documento foi criado com sucesso.' }
      else
        format.html { render action: 'new' }
      end
    end
  end

  def update
    respond_to do |format|
      if @document.update(document_params)
        format.html { redirect_to records_documents_path, notice: 'Documento foi atualizado com sucesso' }
      else
        format.html { render action: 'edit' }
      end
    end
  end

  private

  def set_document
    @document = Document.find(params[:id])
  end

  def document_params
    params.require(:document).permit(:name, :description, :subject, :upload_type, :status, :required_for_certificate)
  end
end
