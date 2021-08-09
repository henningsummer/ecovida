# == Schema Information
#
# Table name: dac_documents
#
#  id               :integer          not null, primary key
#  approved_at      :date
#  dac_date         :date
#  file             :string
#  observations     :text
#  rejection_reason :text
#  status           :string
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  group_id         :integer
#
# Indexes
#
#  index_dac_documents_on_group_id  (group_id)
#
# Foreign Keys
#
#  fk_rails_...  (group_id => groups.id)
#
class DacDocument < ActiveRecord::Base
  belongs_to :group

  mount_uploader :file, DocumentFileUploader

  has_enumeration_for :status, with: DocumentStatus

  validates_presence_of :file

  scope :accepted, -> { where(status: 'accepted') }

  def expire_at
    (dac_date + 1.year).strftime('%d/%m/%Y')
  end
end
