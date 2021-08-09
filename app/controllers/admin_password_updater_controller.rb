class AdminPasswordUpdaterController < ApplicationController
  before_action :require_admin

  def new
    @admin_password_updater = AdminPasswordUpdater.new
  end

  def create
    @admin_password_updater = AdminPasswordUpdater.new(admin_password_updater_params)
    @admin_password_updater.admin_id = current_user

    if @admin_password_updater.save
      redirect_to root_path, notice: "Senha do administrador alterada com sucesso"
    else
      render :new
    end
  end

  private

  def admin_password_updater_params
    params.require(:admin_password_updater).permit(:admin_id, :password, :password_confirmation)
  end
end
