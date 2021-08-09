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
require 'rails_helper'

RSpec.describe Document, type: :model do
  context 'validations' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:status) }
    it { is_expected.to validate_presence_of(:upload_type) }
    it { is_expected.to validate_presence_of(:subject) }
  end
end
