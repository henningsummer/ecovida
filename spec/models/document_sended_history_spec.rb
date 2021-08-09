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
require 'rails_helper'

RSpec.describe DocumentSendedHistory, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
