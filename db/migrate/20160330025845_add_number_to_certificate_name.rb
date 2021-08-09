class AddNumberToCertificateName < ActiveRecord::Migration
  def change
    add_column :certificate_names, :number, :string
    add_column :certificate_names, :number_type, :integer
  end
end
