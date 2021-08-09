# == Schema Information
#
# Table name: products
#
#  id                  :integer          not null, primary key
#  name                :string
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  product_category_id :integer
#
# Indexes
#
#  index_products_on_product_category_id  (product_category_id)
#
# Foreign Keys
#
#  fk_rails_...  (product_category_id => product_categories.id)
#
class Product < ActiveRecord::Base	
	validates_presence_of :name, :product_category_id
 	belongs_to :product_category
  has_many :certificate_products, dependent: :destroy
  has_many :scope_products, dependent: :destroy
end
