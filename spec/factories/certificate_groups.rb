# == Schema Information
#
# Table name: certificate_groups
#
#  id              :integer          not null, primary key
#  coordinate_name :string
#  core_name       :string
#  group_name      :string
#  meeting_date    :date
#  meeting_number  :string
#  meeting_page    :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  city_id         :integer
#  group_id        :integer
#
# Indexes
#
#  index_certificate_groups_on_city_id   (city_id)
#  index_certificate_groups_on_group_id  (group_id)
#
# Foreign Keys
#
#  fk_rails_...  (city_id => cities.id)
#  fk_rails_...  (group_id => groups.id)
#
FactoryGirl.define do
  factory :certificate_group do |certificate_group|
    core_name { |c| "#{c.group.core.name}" }
    group
    group_name { |c| "#{c.group.name}" }
    meeting_date { DateTime.now }
    meeting_number { (1..100).to_a.sample }
    meeting_page { (1..100).to_a.sample }
  end
end
