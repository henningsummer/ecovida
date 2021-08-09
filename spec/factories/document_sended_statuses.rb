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
FactoryGirl.define do
  factory :document_sended_status do
    document_sended
    status "pending"
  end
end
