require 'rails_helper'

RSpec.describe GroupService, type: :service do
  subject { described_class }

  describe '#change_to_core' do
    subject { described_class.new(group).change_to_core(core_after) }

    let(:state) { create(:state, uf: 'RS') }

    let(:core_before) { create(:core, next_farmer_count: 0, state: state, number_from_state: 1) }
    let(:core_after) { create(:core, next_farmer_count: 5, state: state, number_from_state: 5) }

    let(:group) { create(:group, excluded: false, core: core_before) }
    let(:another_group) { create(:group, excluded: false, core: core_before) }


    before do
      Farmer.destroy_all
      
      @farmer_one = create(:farmer, group: group)
      @farmer_two = create(:farmer, group: group)

      core_before.reload
    end
    it 'change group core' do
      subject

      group.reload

      expect(group.core).to eq(core_after)
    end

    it 'upgrade core_after next_farmer_count' do
      subject

      core_after.reload

      expect(core_after.next_farmer_count).to eq(7)
    end

    it 'after create a new farmer in old core, starts on the same next farmer count' do
      subject

      farmer = create(:farmer, group: another_group)

      expect(farmer.farmer_code).to eq('RS01003')
    end

    it 'upgrade de farmers codes' do
      subject

      @farmer_one.reload
      @farmer_two.reload

      expect(@farmer_one.farmer_code).to eq('RS02006')
      expect(@farmer_two.farmer_code).to eq('RS02007')
    end
  end

  describe '#destroy' do
    let!(:group) { create(:group, excluded: false) }
    let!(:farmer) { create(:farmer, group: group, excluded: false) }
    let!(:production_unity) { create(:production_unity_normal, group: group, excluded: false) }

    it 'set group excluded to false' do
      service = subject.new(group)

      service.destroy

      group.reload
      farmer.reload
      production_unity.reload

      expect(production_unity.excluded).to eq(true)
      expect(farmer.excluded).to eq(true)
      expect(farmer.excluded_with_group).to eq(true)
      expect(production_unity.excluded_with_group).to eq(true)
      expect(group.excluded).to eq(true)
    end
  end
end
