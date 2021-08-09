# == Schema Information
#
# Table name: dacs
#
#  id         :integer          not null, primary key
#  added_by   :string
#  dac_date   :date
#  sampling   :boolean
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  farmer_id  :integer
#
# Indexes
#
#  index_dacs_on_farmer_id  (farmer_id)
#
# Foreign Keys
#
#  fk_rails_...  (farmer_id => farmers.id)
#
class Dac < ActiveRecord::Base
  belongs_to :farmer

  validates :dac_date,  presence: true
  validates :farmer_id, presence: true

  # Se precisar, implenetar D.A.C no sigorg, só descomentar.

  # before_create do
  #   changes = []
  #   por_amostragem = self.sampling ? "Por Amostragem" : "Não foi por amostragem"
  #   changes << ["Nova D.A.C criada às: #{DateTime.now.strftime("%H:%M:%S")}" => "Data da D.A.C: #{self.dac_date.strftime("%d/%m/%Y")} - #{por_amostragem}"]

  #   farmer = Farmer.find(self.farmer_id)

  #   farmer.update_sig_org(changes)

  # end

  # before_destroy do
  #   changes = []
  #   por_amostragem = self.sampling ? "Por Amostragem" : "Não foi por amostragem"
  #   changes << ["D.A.C Deletada às: #{DateTime.now.strftime("%H:%M:%S")}" => "D.A.C da data: #{self.dac_date.strftime("%d/%m/%Y")} - #{por_amostragem}"]

  #   farmer = Farmer.find(self.farmer_id)
  #   farmer.update_sig_org(changes)

  # end

end
