class UserSessionsController < ApplicationController
	def new
		@user_session = UserSession.new(session, {login: '', password: ''})
	end

	def create
		@user_session = UserSession.new(session, params[:user_session])
		if @user_session.authenticate!
			redirect_to root_path, notice: 'Seja bem vindo, logado com sucesso.'
		else
			render :new
		end
	end

	def destroy
		user_session.destroy
		redirect_to new_user_sessions_path, notice: 'Deslogado com sucesso. Volte sempre!'
	end

	private


end
