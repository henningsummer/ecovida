class DocumentVisualizationSession
  include ActiveModel::Model

  attr_accessor :access_key

  validates_presence_of :access_key

  def initialize(session, attributes={})
    @session = session
    @access_key = attributes[:access_key]
  end

  def authenticate!
    if valid_access_key?
      store(@access_key)
    else
      errors.add(:base, 'A chave informada expirou')
      nil
    end
  end

  def valid_access_key?
    DocumentVisualization.find_by_access_key(@access_key).try(:valid_date?)
  end

  def guest_user_signed_in?
    DocumentVisualization.find_by_access_key(@session[:access_key]).try(:valid_date?)
  end

  def destroy
    @session[:access_key] = nil
  end

  private

  def store(access_key)
    @session[:access_key] = access_key
  end

end
