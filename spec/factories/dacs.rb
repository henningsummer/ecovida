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
FactoryGirl.define do
  factory :dac do
    dac_date Time.zone.today
    farmer
    sampling [true, false].sample
  end

  factory :invalid_dac, parent: :dac do
    dac_date nil
    farmer nil
    sampling nil
  end
end
