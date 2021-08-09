# == Schema Information
#
# Table name: sigorgs
#
#  id                  :integer          not null, primary key
#  sig_org_type        :string
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  farmer_id           :integer
#  production_unity_id :integer
#
# Indexes
#
#  index_sigorgs_on_farmer_id            (farmer_id)
#  index_sigorgs_on_production_unity_id  (production_unity_id)
#
# Foreign Keys
#
#  fk_rails_...  (farmer_id => farmers.id)
#  fk_rails_...  (production_unity_id => production_unities.id)
#
class Sigorg < ActiveRecord::Base
  belongs_to :farmer
  belongs_to :production_unity
  has_many :column_changes, class_name: 'SigorgChange'
  TYPES = ['Desatualizada', 'Atualizada']

  validates_inclusion_of :sig_org_type, in: TYPES



  def update_changes(changes)
    changes.each do |change|
      change[0].each do |column, value|
        @exists = SigorgChange.where(sigorg_id: self.id, changed_column: column)
        if @exists.count != 0 #Já existe?
            @exists.first.destroy #Então mata !
        end
        @change = self.column_changes.build(changed_column: "às #{DateTime.now.strftime("%H:%M:%S")} - #{column} ", value: value, change_date: Date.today)
        @change.save
      end
    end
  end


  def self.OUTDATED
    TYPES[0]
  end
  def self.UPDATED
    TYPES[1]
  end
end
