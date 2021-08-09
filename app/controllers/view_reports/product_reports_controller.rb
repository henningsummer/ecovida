module ViewReports
  class ProductReportsController < ApplicationController
    before_action :require_admin

    def index
      if params[:commit].present?
        @products = Reports::DynamicProductsReport.new.filter(params_for(params))
      else
        @products = { products: [], count: 0 }
      end
    end

    private

    def params_for(params)
      params[:report].compact.select { |_k, v| v != '' }.merge(page: params[:page])
    end
  end
end
