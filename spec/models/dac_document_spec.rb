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
require 'rails_helper'

RSpec.describe DacDocument, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
