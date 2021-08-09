# == Schema Information
#
# Table name: certificate_products
#
#  id              :integer          not null, primary key
#  contain_organic :boolean
#  name            :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  certificate_id  :integer
#  product_id      :integer
#
# Indexes
#
#  index_certificate_products_on_certificate_id  (certificate_id)
#  index_certificate_products_on_product_id      (product_id)
#
# Foreign Keys
#
#  fk_rails_...  (certificate_id => certificates.id)
#  fk_rails_...  (product_id => products.id)
#
class CertificateProduct < ActiveRecord::Base
  belongs_to :certificate
  belongs_to :product
end
