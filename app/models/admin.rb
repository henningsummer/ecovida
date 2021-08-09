# == Schema Information
#
# Table name: admins
#
#  id              :integer          not null, primary key
#  name            :string
#  login           :string           not null
#  password_digest :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
class Admin < ActiveRecord::Base
	has_secure_password
  validates_uniqueness_of :login
  validates_presence_of :login, :name
  # validates_format_of :login, with: /^[a-z0-9_-]{3,16}$/, multiline: true, message:  'é inválido, por favor, utilize letras de a-z, numeros 1-9 e não use espaços ou caracteres especiais'

	def self.authenticate(login, password)
		admin = Admin.find_by(login: login).try(:authenticate, password)
		return admin
	end

  private

   def validar_login
      if(Group.find_by(login: self.login) or Core.find_by(login: self.login))
        errors.add(:login, "Já está sendo utilizado")
      end
   end
end
