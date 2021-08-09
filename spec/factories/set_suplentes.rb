# == Schema Information
#
# Table name: set_suplentes
#
#  id          :integer          not null, primary key
#  added_by    :string
#  description :text
#  set_type    :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  farmer_id   :integer
#  group_id    :integer
#
# Indexes
#
#  index_set_suplentes_on_farmer_id  (farmer_id)
#  index_set_suplentes_on_group_id   (group_id)
#
# Foreign Keys
#
#  fk_rails_...  (farmer_id => farmers.id)
#  fk_rails_...  (group_id => groups.id)
#
FactoryGirl.define do
  factory :set_suplente do
    added_by "admin"
    description "Troca de suplente"
    group
    farmer
    set_type [1, 2].sample
  end

  factory :invalid_set_suplente, parent: :set_suplente do
    added_by nil
    description nil
    group nil
    farmer nil
    set_type nil
  end
end
