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
FactoryGirl.define do
  factory :production_unity_scope do
  end

  factory :producion_unity_scope_to_agribusiness, parent: :production_unity_scope do
    scope_id { FactoryGirl.create(:scope, scope_type: 2).id }
    production_unity { FactoryGirl.create(:cpf_agribusiness, scope_type: 2) }
  end

  factory :production_unity_scope_to_production_unity, parent: :production_unity_scope do
    scope_id { FactoryGirl.create(:scope, scope_type: 1).id }
    production_unity { FactoryGirl.create(:production_unity_normal, scope_type: 1) }
  end

  factory :invalid_production_unity_scope, parent: :production_unity_scope do
    scope_id nil
    production_unity nil
  end
end
