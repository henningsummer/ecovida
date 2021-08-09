# == Schema Information
#
# Table name: daps
#
#  id            :integer          not null, primary key
#  added_by      :string
#  dap_number    :string
#  emission_date :date
#  validity      :date
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  farmer_id     :integer
#
# Indexes
#
#  index_daps_on_farmer_id  (farmer_id)
#
# Foreign Keys
#
#  fk_rails_...  (farmer_id => farmers.id)
#
class Dap < ActiveRecord::Base
  belongs_to :farmer

  validates :emission_date, presence: true
  validates :validity,      presence: true
  validates :dap_number,    presence: true
  validates :farmer_id,     presence: true

  validate :date_validation

  before_create do
    changes = []
    changes << ["Nova D.A.P" => "Data de validade D.A.P: #{self.validity.strftime("%d/%m/%Y")} - Data de emissão: #{self.emission_date.strftime("%d/%m/%Y")} - Numero da DAP: #{self.dap_number}"]

    farmer = Farmer.find(self.farmer_id)

    farmer.update_sig_org(changes)
  end

  before_destroy do
    changes = []
    changes << [" D.A.P Deletado" => "Data de validade D.A.P: #{self.validity.strftime("%d/%m/%Y")} - Data de emissão: #{self.emission_date.strftime("%d/%m/%Y")} - Numero da DAP: #{self.dap_number}"]

    farmer = Farmer.find(self.farmer_id)
    farmer.update_sig_org(changes)
  end

  private

  def date_validation
    if(emission_date.present? and validity.present?)
      errors.add(:emission_date, "Data de emissão não pode ser maior ou igual que a validade") if self.emission_date >= self.validity
      errors.add(:emission_date, "A data de emissão não pode estar no futuro.") if self.emission_date > DateTime.now
    end
  end



end
