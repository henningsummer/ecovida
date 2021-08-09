class SystemSettingsController < ApplicationController
  before_action :require_admin

  def index
    @system_settings = SystemSetting.all.first
  end

  def edit
    @system_settings = SystemSetting.all.first
  end

  def update
    @system_settings = SystemSetting.all.first
    params = settings_params if user_type == 4

    if @system_settings.update(params)
      SystemLog.create(
        description: "Atualizou informações das Configurações do Sistema",
        author: name_and_type_of_logged_user
      )
      redirect_to root_path, notice: 'Atualizou informações das Configurações do Sistema'
    else
      redirect_to :index, alert: 'Não foi possivel atualizar as informações'
    end
  end

  private
  def settings_params
    params
      .require(:system_setting)
      .permit(
        :basic_annuity_rate,
        :single_agribusiness_rate,
        :basic_propertyless_member_rate
      )
  end

end
