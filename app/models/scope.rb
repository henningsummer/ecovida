# == Schema Information
#
# Table name: scopes
#
#  id         :integer          not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  acronym    :string
#  scope_type :integer
#
class Scope < ActiveRecord::Base
  validates_presence_of :name, :acronym, :scope_type
  has_many :product_scopes
  has_many :product_categories
  def self.SCOPE_TYPES
    [["Unidade de produção", 1], ["Agroindustria", 2]]
  end

  def products
    products = []
    product_scopes.each do |ps|
      products << ps.product
    end
    products
  end
end
