# == Schema Information
#
# Table name: certificate_addresses
#
#  id             :integer          not null, primary key
#  address        :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  certificate_id :integer
#
# Indexes
#
#  index_certificate_addresses_on_certificate_id  (certificate_id)
#
# Foreign Keys
#
#  fk_rails_...  (certificate_id => certificates.id)
#
require 'rails_helper'

RSpec.describe CertificateAddress, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
