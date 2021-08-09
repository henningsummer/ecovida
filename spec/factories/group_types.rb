# == Schema Information
#
# Table name: group_types
#
#  id          :integer          not null, primary key
#  description :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
FactoryGirl.define do |group_type|
  factory :group_type do
    description { |gp| "Group Type number #{GroupType.count}"  }
  end

  factory :invalid_group_type, parent: :group_type do
    description nil
  end
end
