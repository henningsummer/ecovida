module ViewReports
  class FarmerReportsController < ApplicationController
    before_action :require_admin

    def index
      if @farmers = params[:commit].present?
        @items = Reports::FarmersReport.new.filter(params_for(params)).order(:name)
        @count = @items.count
        @farmers = @items.page(params[:page]).per(25)
      else
        @farmers = []
      end
    end

    private

    def params_for(params)
      params[:report].compact.select { |_k, v| v != '' }
    end
  end
end
