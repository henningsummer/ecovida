class AddDacDateToCertificate < ActiveRecord::Migration
  def change
    add_column :certificates, :dac_date, :datetime
  end
end
