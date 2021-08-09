# == Schema Information
#
# Table name: document_sendeds
#
#  id               :integer          not null, primary key
#  approved_at      :string
#  file             :string
#  observations     :text
#  rejection_reason :text
#  status           :string
#  subject_type     :string
#  url              :string
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  document_id      :integer
#  subject_id       :integer
#
# Indexes
#
#  index_document_sendeds_on_document_id                  (document_id)
#  index_document_sendeds_on_subject_type_and_subject_id  (subject_type,subject_id)
#
# Foreign Keys
#
#  fk_rails_...  (document_id => documents.id)
#
FactoryGirl.define do
  factory :document_sended do
    document
    subject_id nil
    subject_type nil
    status "pending"
    approved_at nil
    url nil
    observations nil
  end

  factory :document_sended_attributes, class: OpenStruct do
    document
    status "pending"
    subject_id nil
    subject_type nil
    approved_at nil
    url nil
    observations nil
  end
end
