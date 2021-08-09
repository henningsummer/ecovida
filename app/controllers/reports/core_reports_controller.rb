module Reports
  class CoreReportsController < ApplicationController
    before_action :set_core

    def actual_situation
      Reports::ActualSituationReport.new(@core).process(params[:core][:email])

      head :ok
    end

    def products
      Reports::ProductsReport.new(@core.first.groups).process(params[:core][:email])

      head :ok
    end

    private

    def set_core
      @core = Core.where(id: params[:core][:id])
    end
  end
end
