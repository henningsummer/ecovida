require 'rails_helper'

RSpec.describe FarmerService, type: :service do
  subject { described_class }

  let!(:production_unity) { create(:production_unity_normal) }

  context '.destroy' do
    it 'change excluded atribute to true' do
      subject.destroy(production_unity)

      production_unity.reload

      expect(production_unity.excluded).to eq(true)
    end
  end
end
