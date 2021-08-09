class AdminPasswordUpdater
  include ActiveModel::Model

  attr_accessor :admin_id, :password, :password_confirmation

  validates :password, :password_confirmation, presence: true
  validate :password_confirmation_must_equals_password


  def save
    if valid?
      admin.update!(password: password, password_confirmation: password_confirmation)
    end
  end

  private

  def admin
    Admin.find(admin_id)
  end

  def password_confirmation_must_equals_password
    errors.add(:password_confirmation, "A confirmação de senha deve ser igual a senha") unless password == password_confirmation
  end
end
