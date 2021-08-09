module ViewReports
  class ProductionUnityReportsController < ApplicationController
    before_action :require_admin

    def index
      @q = ProductionUnity.order(name: :asc).includes(:city, :group).ransack(params[:q])
      @count = @q.result.count
      @count = @count.count if @count.is_a?(Hash)
      @production_unities = @q.result.page(params[:page]).per(25)
      @scope_types = [["Unidade de produção", 1], ["Agroindústria", 2]]
      @cities = City.all.order(:name).map { |city| [city.name, city.id] }
      @states = State.all.order(:uf).map { |state| [state.uf, state.id] }
      @cores = Core.all.order(:name).map { |core| [core.name, core.id] }
      @groups = Group.all.order(:name).map { |group| [group.name, group.id] }
      @products = Product.all.order(:name)
    end
  end
end
