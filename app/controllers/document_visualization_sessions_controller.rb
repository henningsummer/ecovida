class DocumentVisualizationSessionsController < ApplicationController
  def new
    @document_visualization_session = DocumentVisualizationSession.new(session, {access_key: ''})
  end

  def create
    @document_visualization_session = DocumentVisualizationSession.new(session, params[:document_visualization_session])
    if @document_visualization_session.authenticate!
      redirect_to :document_access_visualizations_core
    else
      render :new
    end
  end

  def destroy
    document_visualization_session.destroy
    redirect_to new_document_visualization_sessions_path, notice: 'Logout realizado com sucesso'
  end

  private

  def access_key
    params[:document_visualization_session][:access_key]
  end
end
