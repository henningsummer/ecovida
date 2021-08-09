# == Schema Information
#
# Table name: farmers
#
#  id                   :integer          not null, primary key
#  address              :string
#  birthday             :date
#  cell_phone           :string
#  contract_of_adhesion :boolean          default(FALSE)
#  em_ata               :boolean
#  email                :string
#  excluded             :boolean
#  excluded_with_group  :boolean          default(FALSE)
#  farmer_code          :string
#  gender               :string
#  lembrete             :text
#  name                 :string
#  neighborhood         :string
#  number               :string
#  number_type          :integer
#  phone_number         :string
#  rg                   :string
#  spouse               :string
#  spouse_birthday      :date
#  spouse_cpf           :string
#  spouse_gender        :string
#  suspended            :boolean
#  termo_compromisso    :boolean
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  city_id              :integer
#  group_id             :integer
#
# Indexes
#
#  index_farmers_on_city_id   (city_id)
#  index_farmers_on_group_id  (group_id)
#
# Foreign Keys
#
#  fk_rails_...  (city_id => cities.id)
#  fk_rails_...  (group_id => groups.id)
#
require 'rails_helper'

RSpec.describe Farmer, type: :model do
  context 'associations' do
    it { is_expected.to belong_to(:city) }
    it { is_expected.to belong_to(:group) }

    it { is_expected.to have_many(:farmer_group_changes) }
    it { is_expected.to have_many(:farmer_families) }
    it { is_expected.to have_many(:set_suplentes) }
    it { is_expected.to have_many(:production_unity_farmers ) }
    it { is_expected.to have_many(:dacs) }
    it { is_expected.to have_many(:daps) }
    it { is_expected.to have_many(:farmer_suspensions) }
    it { is_expected.to have_many(:sigorgs) }
  end

  context "spouse_cpf can be blank" do
    it do
      expect do
        5.times do
          create(:farmer, spouse_cpf: nil)
        end
      end.not_to raise_error
    end
  end

  context 'validations' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:address) }
    it { is_expected.to validate_presence_of(:neighborhood) }
    it { is_expected.to validate_presence_of(:group_id) }
    it { is_expected.to validate_presence_of(:city_id) }
  end

  context 'factory' do
    it { expect(build(:farmer)).to be_valid }
    it { expect(build(:invalid_farmer)).to_not be_valid }
  end

  describe '.before_save' do
    context 'when CNPJ' do
      let(:farmer) { build(:farmer, number_type: 2, number: cnpj) }

      context 'with valid cnpj' do
        let(:cnpj) { '24.052.852/0001-90' }

        it 'transformed to stripped cnpj' do
          farmer.save

          farmer.reload

          expect(farmer.number).to eq('24052852000190')
        end
      end

      context 'with invalid cnpj' do
        let(:cnpj) { 666 }

        it 'change nothing' do
          farmer.save

          expect(farmer.number).to eq('666')
        end
      end
    end

    context 'when CPF' do
      let(:farmer) { build(:farmer, number_type: 1, number: cpf) }

      context 'with valid cpf' do
        let(:cpf) { '034.819.290-80' }

        it 'transformed to stripped cpf' do
          farmer.save

          farmer.reload

          expect(farmer.number).to eq('03481929080')
        end
      end

      context 'with invalid cpf' do
        let(:cpf) { 666 }

        it 'change nothing' do
          farmer.save

          expect(farmer.number).to eq('666')
        end
      end
    end
  end

  it '#generate_code' do
    group_one = create(:group)
    group_two = create(:group)

    farmer_one = create(:farmer, group: group_one)
    farmer_two = create(:farmer, group: group_one)

    22.times do
      create(:farmer, group: group_two)
    end

    expect(farmer_one.farmer_code).to eq("#{group_one.core.state.uf}0#{group_one.core.number_from_state}001")
    expect(farmer_two.farmer_code).to eq("#{group_one.core.state.uf}0#{group_one.core.number_from_state}002")

    expect(Farmer.last.farmer_code).to eq("#{group_two.core.state.uf}0#{group_two.core.number_from_state}022")
  end
end
