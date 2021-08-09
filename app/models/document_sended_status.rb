# == Schema Information
#
# Table name: document_sended_statuses
#
#  id                 :integer          not null, primary key
#  reason             :string
#  status             :string
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  document_sended_id :integer
#
# Indexes
#
#  index_document_sended_statuses_on_document_sended_id  (document_sended_id)
#
# Foreign Keys
#
#  fk_rails_...  (document_sended_id => document_sendeds.id)
#
class DocumentSendedStatus < ActiveRecord::Base
  has_enumeration_for :status, with: DocumentStatus
  validates_presence_of :status

  belongs_to :document_sended
end
