module Reports
  class GlobalReportsController < ApplicationController
    before_action :require_admin

    def actual_situation
      Reports::ActualSituationReport.new(Core.all).process(params[:core][:email])

      head :ok
    end

    def certificate_documents
      Reports::CertificatesReport.new(certificate_params.deep_symbolize_keys).process

      redirect_to reports_index_path, notice: 'Seu relatório será enviado para seu e-mail'
    end

    def annuity
      Reports::AnnuityReport.new(Core.all.order(:name), params[:year]).process(params[:core][:email])

      head :ok
    end

    private

    def certificate_params
      params.require(:report).permit(:from, :to, :email, :core_id)
    end
  end
end
