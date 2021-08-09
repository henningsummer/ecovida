class ExcludedData::GroupsController < ApplicationController
  before_action :require_admin

  def index
    @q  = Group.unscoped.order(name: :asc).where(excluded: true).ransack(params[:q])
    @count = @q.result.count
    @groups = @q.result.page(params[:page]).per(25)
  end
end
