class AddUserTypeAndCurrentUserToSetSuplente < ActiveRecord::Migration
  def change
    add_column :set_suplentes, :current_user, :integer
    add_column :set_suplentes, :user_type, :integer
  end
end
