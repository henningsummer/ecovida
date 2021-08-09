# == Schema Information
#
# Table name: certificate_families
#
#  id               :integer          not null, primary key
#  name             :string
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  certificate_id   :integer
#  farmer_family_id :integer
#
# Indexes
#
#  index_certificate_families_on_certificate_id    (certificate_id)
#  index_certificate_families_on_farmer_family_id  (farmer_family_id)
#
# Foreign Keys
#
#  fk_rails_...  (certificate_id => certificates.id)
#  fk_rails_...  (farmer_family_id => farmer_families.id)
#
require 'rails_helper'

RSpec.describe CertificateFamily, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
