# == Schema Information
#
# Table name: document_sended_histories
#
#  id                 :integer          not null, primary key
#  approved_at        :date
#  file               :string
#  url                :string
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  document_sended_id :integer
#
# Indexes
#
#  index_document_sended_histories_on_document_sended_id  (document_sended_id)
#
# Foreign Keys
#
#  fk_rails_...  (document_sended_id => document_sendeds.id)
#
FactoryGirl.define do
  factory :document_sended_history do
    document_sended nil
    file "MyString"
  end
end
