# == Schema Information
#
# Table name: certificates
#
#  id                   :integer          not null, primary key
#  certificate_type     :string
#  city_name            :string
#  dac_date             :datetime
#  number               :string
#  number_type          :string
#  pruduction_quantity  :integer
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  certificate_group_id :integer
#
# Indexes
#
#  index_certificates_on_certificate_group_id  (certificate_group_id)
#
# Foreign Keys
#
#  fk_rails_...  (certificate_group_id => certificate_groups.id)
#
require 'rails_helper'

RSpec.describe Certificate, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
