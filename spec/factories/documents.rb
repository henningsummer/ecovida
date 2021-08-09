# == Schema Information
#
# Table name: documents
#
#  id                       :integer          not null, primary key
#  name                     :string
#  description              :text
#  subject                  :string
#  upload_type              :string
#  status                   :string
#  required_for_certificate :string
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#
FactoryGirl.define do
  factory :document do
    name "MyString"
    description "MyText"
    subject "farmer"
    upload_type 'only_pdf'
    status 'active'
    required_for_certificate 'yes_answer'
  end
end
