class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  delegate :current_user, :user_signed_in?, :user_type, :user_name, to: :user_session
  delegate :guest_user_signed_in?, to: :document_visualization_session
  helper_method :current_user, :user_signed_in, :user_type, :user_name, :require_current_or_admin, :can_generate_certificate?,
                :is_admin?, :current_user_instance
  before_action :require_authentication, only: [:require_admin, :require_super_core, :require_normal_core]
  before_filter :set_cache_buster

  respond_to :html

  def set_cache_buster
    response.headers["Cache-Control"] = "no-cache, no-store, max-age=0, must-revalidate"
    response.headers["Pragma"] = "no-cache"
    response.headers["Expires"] = "Fri, 01 Jan 1990 00:00:00 GMT"
  end

  # Users Types
  # ADM: 4
  # super_core: 3
  # Normal_core: 2
  # Group: 1


  #Funções de autenticação, para serem utilizadas

  def is_admin?
    user_type == 4
  end

  def can_generate_certificate?
    return true if user_type == 4

    return false if Core.find(current_user).inactive_certificate

    true
  end

  #Pode ser usada em helpers e no controller, return true se tiver ok
  #E false e nao for admin ou o current user
  def require_current_or_admin(user, is_helper = false, needs_sig_org_access = false)
    if user_type == 4 or (user == current_user and user_type > 1) #Se for o o core, pra não dar problema com grupo com mesmo id.
      if not needs_sig_org_access or user_type == 4 #Adm não precisa passar pela verificação.  Por isso o user_type == 4
        true
      else
        core = Core.find(user)
        if core.sig_org_access
          true
        else
          redirect_to root_path, alert: '´Area restrita' unless is_helper
          false if is_helper
        end
      end
    else
      redirect_to root_path, alert: '´Area restrita' unless is_helper
      false if is_helper
    end
  end

  def current_user_instance
    EcovidaUtils::UserModel.execute(user_type, current_user)
  end

  def name_and_type_of_logged_user
    #Retorna o nome e o tipo do usuario logado
    if user_type == 4 #ADM?
      admin = Admin.find(current_user)
      "Administrador: #{admin.name} - #{admin.id}"
    elsif user_type == 3 or user_type == 2 #Núcleo ?
      core = Core.find(current_user)
      "Nucleo: #{core.name} - #{core.id}"
    else
      group = Group.find(current_user)
      "Grupo: #{group.name} - #{group.id}"
    end
  end

  def only_core
    if !([1,2,3].include?(user_type))
      redirect_to root_path, alert: 'Área restrita'
    end
  end

  def require_admin
    if user_type < 4
      redirect_to root_path, alert: 'Área restrita'
    end
  end

  def require_super_core
    if user_type < 3
      redirect_to root_path, alert: 'Área restrita'
    end
  end

  def require_normal_core
    if user_type < 2
      redirect_to root_path, alert: 'Área restrita'
    end
  end

  def require_authentication
    unless user_signed_in?
      redirect_to new_user_sessions_path, alert: 'Área restrita'
    end
  end

  def require_authentication_for_guest_user
    unless guest_user_signed_in?
      document_visualization_session.destroy
      redirect_to new_document_visualization_sessions_path, alert: 'A chave informada expirou'
    end
  end

  def user_session
    UserSession.new(session)
  end

  def document_visualization_session
    DocumentVisualizationSession.new(session)
  end
end
