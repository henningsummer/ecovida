# == Schema Information
#
# Table name: farmer_families
#
#  id         :integer          not null, primary key
#  birthday   :date
#  cpf        :string
#  gender     :string
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  farmer_id  :integer
#
# Indexes
#
#  index_farmer_families_on_farmer_id  (farmer_id)
#
# Foreign Keys
#
#  fk_rails_...  (farmer_id => farmers.id)
#
class FarmerFamily < ActiveRecord::Base
  validates_presence_of :name, :farmer_id, :cpf
  belongs_to :farmer
  validate :validate_cpf_number
  has_enumeration_for :gender, with: Genders

  validates_uniqueness_of :cpf

  validates_date :birthday, before: Date.today, before_message: 'deve ser em uma data no passado', on: :create, if: :birthday

  def self.text_search(query)
    joins(:farmer).where(["farmer_families.name ILIKE :query or farmer_families.cpf ILIKE :query AND farmers.excluded = false" , query: "%#{query}%"])
  end

  has_many :certificate_families, dependent: :nullify

  before_validation do
    cpf_class = CPF.new(cpf)
    self.cpf = cpf_class.stripped if cpf_class.valid?
  end

  def validate_cpf_number
    if self.cpf.present?
      require 'cpf_cnpj'
      errors.add(:cpf, 'CPF está inválido') unless CPF.valid? self.cpf
    end
  end
end
