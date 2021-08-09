# == Schema Information
#
# Table name: product_categories
#
#  id         :integer          not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  scope_id   :integer
#
# Indexes
#
#  index_product_categories_on_scope_id  (scope_id)
#
# Foreign Keys
#
#  fk_rails_...  (scope_id => scopes.id)
#
class ProductCategory < ActiveRecord::Base
  has_many :products, dependent: :destroy
  belongs_to :scope
  validates_presence_of :name, :scope_id

  def self.all_products
          all.collect {|c| ["#{c.name} - #{c.scope.name}", c.id]}
  end	
end
