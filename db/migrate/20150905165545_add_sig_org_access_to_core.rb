class AddSigOrgAccessToCore < ActiveRecord::Migration
  def change
    add_column :cores, :sig_org_access, :boolean
  end
end
