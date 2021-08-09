# == Schema Information
#
# Table name: dac_documents
#
#  id               :integer          not null, primary key
#  approved_at      :date
#  dac_date         :date
#  file             :string
#  observations     :text
#  rejection_reason :text
#  status           :string
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  group_id         :integer
#
# Indexes
#
#  index_dac_documents_on_group_id  (group_id)
#
# Foreign Keys
#
#  fk_rails_...  (group_id => groups.id)
#
FactoryGirl.define do
  factory :dac_document do
    group nil
    file "MyString"
    dac_date "2018-06-05"
  end
end
