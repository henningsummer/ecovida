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
require 'rails_helper'

RSpec.describe DocumentSended, type: :model do
  it { is_expected.to validate_presence_of(:status) }
  it { is_expected.to validate_presence_of(:document_id) }
  it { is_expected.to validate_presence_of(:subject_id) }
end
