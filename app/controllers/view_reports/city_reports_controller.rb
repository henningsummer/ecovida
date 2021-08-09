module ViewReports
  class CityReportsController < ApplicationController
    before_action :require_admin

    def index
      @q = City.farmer_count_asc.ransack(params[:q])
      @cities = @q.result.includes(:state).page(params[:page]).per(25)
      @states = State.order(name: :asc)
    end
  end
end
