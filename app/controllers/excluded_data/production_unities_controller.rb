class ExcludedData::ProductionUnitiesController < ApplicationController
  before_action :require_admin

  def index
    @q  = ProductionUnity.unscoped.order(name: :asc).where(excluded: true).ransack(params[:q])
    @count = @q.result.count
    @production_unities = @q.result.page(params[:page]).per(25)
  end
end
