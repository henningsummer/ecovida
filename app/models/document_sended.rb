# == Schema Information
#
# Table name: document_sendeds
#
#  id               :integer          not null, primary key
#  approved_at      :string
#  file             :string
#  observations     :text
#  rejection_reason :text
#  status           :string
#  subject_type     :string
#  url              :string
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  document_id      :integer
#  subject_id       :integer
#
# Indexes
#
#  index_document_sendeds_on_document_id                  (document_id)
#  index_document_sendeds_on_subject_type_and_subject_id  (subject_type,subject_id)
#
# Foreign Keys
#
#  fk_rails_...  (document_id => documents.id)
#
class DocumentSended < ActiveRecord::Base
  has_enumeration_for :status, with: DocumentStatus

  has_many :document_sended_statuses
  has_many :document_sended_histories, dependent: :destroy
  belongs_to :document
  belongs_to :subject, polymorphic: true

  mount_uploader :file, DocumentFileUploader

  validates :status, presence: true
  validates :subject_id, presence: true
  validates :document_id, presence: true
  validates :url, presence: true, if: :document_only_video?
  validates :file, presence: true, if: :document_only_pdf?
  validate :validate_pdf_or_video

  scope :accepted, -> { where(status: 'accepted').where.not(approved_at: nil) }

  def accepted?
    status == 'accepted' && !approved_at.nil?
  end

  def has_document_history?
    document_sended_histories.any?
  end

  def document_only_pdf?
    return false unless document.present?
    document.only_pdf?
  end

  # Override to silently ignore trying to remove missing
  # previous avatar when destroying a User.
  def remove_file!
    begin
      super
    rescue Fog::Storage::Rackspace::NotFound
      self.file = nil
      self.send(:write_attribute, :file, nil)
    end
  end


  def document_only_video?
    return false unless document.present?
    document.only_video?
  end

  def validate_pdf_or_video
    unless url.present? || file.file.present?
      errors.add(:file)
      return false
    end
  end
end
