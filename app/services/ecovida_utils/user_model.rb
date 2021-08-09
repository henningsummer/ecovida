module EcovidaUtils
  class UserModel
    class << self
      def execute(user_type, user_id)
        case user_type
        when 4
          Admin.find(user_id)
        when 3
          Core.find(user_id)
        when 2
          Core.find(user_id)
        when 1
          Group.find(user_id)
        end
      end
    end
  end
end
