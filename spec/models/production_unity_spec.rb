# == Schema Information
#
# Table name: production_unities
#
#  id                  :integer          not null, primary key
#  address             :string
#  cep                 :string
#  email               :string
#  excluded            :boolean
#  excluded_with_group :boolean          default(FALSE)
#  fantasy_name        :string
#  lat_hour            :integer
#  lat_minute          :integer
#  lat_second          :decimal(, )
#  lat_type            :string
#  lon_hour            :integer
#  lon_minute          :integer
#  lon_second          :decimal(, )
#  lon_type            :string
#  name                :string
#  neighborhood        :string
#  number              :string
#  number_type         :integer
#  phone               :string
#  production_type     :string
#  register_number     :string
#  register_type       :string
#  scope_type          :integer
#  total_area          :string
#  total_native_area   :string
#  total_organic_area  :string
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  city_id             :integer
#  group_id            :integer
#
# Indexes
#
#  index_production_unities_on_city_id   (city_id)
#  index_production_unities_on_group_id  (group_id)
#
# Foreign Keys
#
#  fk_rails_...  (city_id => cities.id)
#  fk_rails_...  (group_id => groups.id)
#
require 'rails_helper'

RSpec.describe ProductionUnity, type: :model do
  context 'agribusiness' do
    context 'cpf' do
      subject{ create(:cpf_agribusiness) }
    end
    context 'cnpj' do
      subject{ create(:cnpj_agribusiness) }
    end
  end
  context 'production unity' do
    subject{ create(:production_unity_normal) }
    context 'validations' do
      it { is_expected.to validate_presence_of :scope_type }
    end
  end

  describe '.before_save' do
    context 'when CNPJ' do
      let(:cnpj_agribusiness) { build(:cnpj_agribusiness, number_type: 2, number: cnpj) }

      context 'with valid cnpj' do
        let(:cnpj) { '24.052.852/0001-90' }

        it 'transformed to stripped cnpj' do
          cnpj_agribusiness.save

          cnpj_agribusiness.reload

          expect(cnpj_agribusiness.number).to eq('24052852000190')
        end
      end

      context 'with invalid cnpj' do
        let(:cnpj) { 666 }

        it 'change nothing' do
          cnpj_agribusiness.save

          expect(cnpj_agribusiness.number).to eq('666')
        end
      end
    end

    context 'when CPF' do
      let(:cpf_agribusiness) { build(:cpf_agribusiness, number_type: 1, number: cpf) }

      context 'with valid cpf' do
        let(:cpf) { '03481929080' }

        it 'transformed to stripped cpf' do
          cpf_agribusiness.save

          cpf_agribusiness.reload

          expect(cpf_agribusiness.number).to eq('03481929080')
        end
      end

      context 'with invalid cpf' do
        let(:cpf) { 666 }

        it 'change nothing' do
          cpf_agribusiness.save

          expect(cpf_agribusiness.number).to eq('666')
        end
      end
    end
  end

  context  'excluded' do
    let!(:production_unity) { create(:production_unity_normal) }
    let!(:excluded_production_unity) { create(:production_unity_normal, excluded: true) }
    let!(:farmer) { create(:farmer) }
    let!(:production_unity_farmer) { create(:production_unity_farmer, farmer: farmer,
                                                                      production_unity: production_unity ) }
    it 'return only non excluded production unities' do
      expect(ProductionUnity.all).to eq([production_unity])
    end

    it 'Dont return in farm query if is excluded' do
      production_unity.update(excluded: true)
      expect(farmer.production_unities).to eq([])
    end
  end

  context 'factory' do
    it { expect(build(:production_unity_normal)).to be_valid }
    it { expect(build(:cpf_agribusiness)).to be_valid }
    it { expect(build(:cnpj_agribusiness)).to be_valid }
    it { expect(build(:invalid_production_unity).valid?).to eq(false)}
  end
end
