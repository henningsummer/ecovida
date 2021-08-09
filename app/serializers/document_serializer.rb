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
class DocumentSerializer < ActiveModel::Serializer
  attributes :id, :name, :description, :subject, :can_be_video
end
