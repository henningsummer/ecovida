class ExcludedData::FarmersController < ApplicationController
  before_action :require_admin

  def index
    @q  = Farmer.unscoped.order(name: :asc).where(excluded: true).ransack(params[:q])
    @count = @q.result.count
    @farmers = @q.result.page(params[:page]).per(25)
  end
end
