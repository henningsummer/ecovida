class ChangeMeetingPageToBeStringInCertificateGroup < ActiveRecord::Migration
  def change
    change_column :certificate_groups, :meeting_page, :string

  end
end
