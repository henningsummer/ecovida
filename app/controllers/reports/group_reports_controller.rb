module Reports
  class GroupReportsController < ApplicationController
    before_action :set_group

    def products
      report = Reports::ProductsReport.new(@group).process(params[:group][:email])

      head :ok
    end

    private

    def set_group
      @group = Group.where(id: params[:group][:id])
    end
  end
end
