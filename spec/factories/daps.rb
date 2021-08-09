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
FactoryGirl.define do
  factory :dap do
    dap_number "abc1234"
    emission_date {Time.zone.today}
    farmer
    validity {Time.zone.today + 2}
  end

  factory :invalid_validity_dap, parent: :dap do
    validity Time.zone.today - 1
  end

  factory :invalid_dap, parent: :dap do
    dap_number nil
    emission_date nil
    farmer nil
    validity nil
  end
end
