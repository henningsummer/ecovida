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
class Document < ActiveRecord::Base
  extend EnumerateIt
  has_enumeration_for :status, with: Status
  has_enumeration_for :subject, with: DocumentSubjects
  has_enumeration_for :upload_type, with: DocumentUploadTypes, create_helpers: true
  has_enumeration_for :required_for_certificate, with: SimpleQuestion, create_helpers: { prefix: true }

  validates_presence_of :name, :status, :subject, :upload_type
end
