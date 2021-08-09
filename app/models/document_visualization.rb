# == Schema Information
#
# Table name: document_visualizations
#
#  id         :integer          not null, primary key
#  access_key :string
#  expire_at  :datetime
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class DocumentVisualization < ActiveRecord::Base
  validates_presence_of :expire_at
  validate :must_be_on_future

  before_create :generate_access_key

  scope :order_by_date, -> { order(expire_at: :desc) }

  def active?
    expire_at > Time.now ? 'Sim' : 'Não'
  end

  def valid_date?
    return false unless expire_at.present?

    expire_at > Time.now ? true : false
  end

  def formated_date
    expire_at.strftime('%d/%m/%Y - %H:%M')
  end

  private

  def must_be_on_future
    return unless expire_at.present?

    if expire_at < Time.now
      errors.add(:expire_at, 'Deve ser em uma data futura')
    end
  end

  def generate_access_key
    self.access_key = SecureRandom.hex(20)
  end
end
