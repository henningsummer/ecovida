class Records::LogsController < ApplicationController
  before_action :require_admin
  def index
    @q = SystemLog.ransack(params[:q])
  	@logs = @q.result.order(created_at: :desc).page(params[:page]).per(50)
  end
end
