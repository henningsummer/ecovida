class UserSession
  include ActiveModel::Model

  validates_presence_of :login, :password
  attr_accessor :login, :password
  def initialize(session, attributes={})

    @session = session
    @login = attributes[:login]
    @password = attributes[:password]

  end

  def current_user
    @session[:user_id]
  end

  def user_signed_in?
    @session[:user_id].present?
  end

  def user_type 
    @session[:user_type] ? @session[:user_type] : 0
  end

  def destroy
    @session[:user_id] = nil
    @session[:user_type] = nil
  end

  def user_name
    @session[:name]
  end

  def authenticate!
    #Aqui ele tentará logar como nucleo, depois grupo e por ultimo, administrador,
    #Se não conseguir, irá retornar nil

    if(admin = Admin.authenticate(@login, @password))
      store(admin, 4)
    elsif core = Core.authenticate(@login, @password)
      core.total_power ? store(core, 3) : store(core, 2)
    elsif group = Group.authenticate(@login, @password)
      store(group, 1)
    else
      errors.add(:base, 'Login inválido')
      nil
    end
  end

  def store(user, user_type)
    @session[:user_id] = user.id
    @session[:user_type] = user_type
    @session[:name] = user.name
  end


end
