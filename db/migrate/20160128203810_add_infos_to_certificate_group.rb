class AddInfosToCertificateGroup < ActiveRecord::Migration
  def change
    add_column :certificate_groups, :core_name, :string
    add_column :certificate_groups, :group_name, :string
    add_column :certificate_groups, :coordinate_name, :string
  end
end
