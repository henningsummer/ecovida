require 'rails_helper'

RSpec.describe SystemSettingsController, type: :controller do
  
  xdescribe 'GET #index' do
    let!(:system_settings) {create :system_setting }
    let!(:admin) { create :admin}
    before do
      get :index
    end
    it { is_expected.to respond_with :ok }
    it { is_expected.to render_with_layout :application }
    it { is_expected.to render_template :index }
  end

end
