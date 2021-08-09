require 'rails_helper'

RSpec.describe Groups::ProductionUnityScopesController, type: :controller do
  describe 'DELETE #destroy' do
    let!(:group) { create(:group) }
    let!(:production_unity) { create(:production_unity_normal, group: group) }
    let!(:production_unity_scope) { create(:production_unity_scope_to_production_unity,
                                            production_unity: production_unity) }
    let!(:product) { create(:scope_product_production_unity, production_unity_scope: production_unity_scope) }

    it 'delete a scope and the products' do
      # FIXME não acha a URL.
      
      # expect do
      #   delete :destroy, group_id: production_unity_scope.production_unity.group,
      #                    production_unity_id: production_unity_scope.production_unity,
      #                    producton_unity_scope_id: production_unity_scope
      # end.to change(ProductionUnityScope, :count).by(-1)
    end
  end
end
