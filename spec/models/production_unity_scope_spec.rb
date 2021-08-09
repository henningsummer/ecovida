# == Schema Information
#
# Table name: production_unity_scopes
#
#  id                      :integer          not null, primary key
#  bushland_area           :float
#  organic_production_area :float
#  total_area              :float
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  production_unity_id     :integer
#  scope_id                :integer
#
# Indexes
#
#  index_production_unity_scopes_on_production_unity_id  (production_unity_id)
#  index_production_unity_scopes_on_scope_id             (scope_id)
#
# Foreign Keys
#
#  fk_rails_...  (production_unity_id => production_unities.id)
#  fk_rails_...  (scope_id => scopes.id)
#
require 'rails_helper'

RSpec.describe ProductionUnityScope, type: :model do
  context 'validations' do
    # it { is_expected.to validate_presence_of :scope_id }
    # it { is_expected.to validate_presence_of :production_unity_id }
  end

  context 'factory' do
    it { expect(build(:producion_unity_scope_to_agribusiness)).to be_valid }
    it { expect(build(:production_unity_scope_to_production_unity)).to be_valid }
    # it { expect(build(:invalid_production_unity_scope)).to_not be_valid }
  end

  context 'associations' do
    pending "Maldita logica no model... (Problema é o validate.)"
    # it { is_expected.to belong_to :scope }
    # it { is_expected.to belong_to :production_unity }
  end
end
