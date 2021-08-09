class AddInactiveCertificateToCore < ActiveRecord::Migration
  def change
    add_column :cores, :inactive_certificate, :boolean, default: :false
  end
end
