require 'rails_helper'

RSpec.describe FarmerService, type: :service do
  subject { described_class }

  let!(:group) { create(:group) }
  let!(:farmer) { create(:farmer, excluded: false) }
  let!(:farmer_two) { create(:farmer, excluded: false) }
  let!(:production_unity) { create(:cpf_agribusiness, excluded: false) }
  let!(:production_unity_two) { create(:cpf_agribusiness, excluded: false) }
  let!(:production_unity_farmer) { create(:production_unity_farmer, production_unity: production_unity,
                                                                    farmer: farmer,
                                                                    is_responsible: true) }

  let!(:production_unity_farmer_two) { create(:production_unity_farmer, production_unity: production_unity,
                                                                    farmer: farmer_two,
                                                                    is_responsible: false) }

  let!(:production_unity_farmer_three) { create(:production_unity_farmer, production_unity: production_unity_two,
                                                                    farmer: farmer,
                                                                    is_responsible: true) }



  context '.destroy' do
    it 'When try to delete a farmer, when hes own the production unity, and no have other farmer, just exclude production unity too' do
      subject.destroy(farmer)

      farmer.reload
      production_unity_two.reload

      expect(farmer.excluded).to eq(true)
      expect(production_unity_two.excluded).to eq(true)
    end

    it 'when he own the production unity, and has a other member too, the other member turns reponsible and dont excluded the production unity' do
      subject.destroy(farmer)

      farmer.reload
      production_unity.reload

      expect(farmer.excluded).to eq(true)
      expect(production_unity.excluded).to eq(false)
      expect(production_unity.responsible).to eq(farmer_two)
    end

    it 'when dont own the production unity, and have more than one in the production, just do nithing' do
      subject.destroy(farmer_two)

      farmer_two.reload
      production_unity.reload

      expect(farmer_two.excluded).to eq(true)
      expect(production_unity.excluded).to eq(false)
      expect(production_unity.responsible).to eq(farmer)
    end
  end
end
