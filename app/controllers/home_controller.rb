class HomeController < ApplicationController
  before_action :require_authentication
  def index
    @document_count = DocumentSended.where(status: 'pending').count
    @dac_count = DacDocument.where(status: 'pending').count
  end
  def report

  end
  def search
    @query = params[:query]
    
    if @query != ""
      @groups = Group.all.text_search(@query).page(params[:group_page]).per(15)
      @farmers = Farmer.all.text_search(@query).page(params[:farm_page]).per(15)
      @farmer_families = FarmerFamily.all.text_search(@query).page(params[:farmer_family_page]).per(15)
      
      if user_type == 4
        @production_unities = ProductionUnity.all.text_search(@query).page(params[:production_unity_page]).per(15)
      elsif user_type.in? 2..3
        @production_unities = Core.find(current_user).production_unities.text_search(@query).page(params[:production_unity_page]).per(15)
      end

    else
      redirect_to root_path, alert: "Digite o que você deseja procurar."
    end
  end
end
