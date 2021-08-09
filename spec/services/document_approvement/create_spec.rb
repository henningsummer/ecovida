require 'rails_helper'

RSpec.describe DocumentApprovement::Create, type: :service do
  # context 'execute' do
  #   subject { described_class.execute(params, current_user) }

  #   let(:params) { build(:document_sended_attributes, subject_id: subject_instance.id, subject_type: subject_instance.class.to_s).to_h }
  #   let(:current_user) { create(:admin) }
  #   let(:subject_instance) { create(:farmer) }

  #   context 'with valid params' do
  #     it { expect(subject.subject).to eq(subject_instance) }
  #   end

  #   context 'permissions test' do
  #     context 'when current_user is core' do
  #       let(:current_user) { create(:core) }

  #       context 'when subject is from a different core' do
  #         let(:subject_instance) { create(:farmer) }

  #         it { is_expected.to be_falsey }
  #       end

  #       context 'when suject is from same core' do
  #         let(:group) { create(:group, core: current_user) }
  #         let(:subject_instance) { create(:production_unity_normal, group_id: group.id) }

  #         it { expect(subject.subject).to eq(subject_instance) }
  #         it { expect(subject.status).to eq('pending') }
  #       end
  #     end

  #     context 'when current_user is group' do
  #       let(:current_user) { create(:group) }

  #       context 'when subject is from a different core' do
  #         let(:subject_instance) { create(:farmer) }

  #         it { is_expected.to be_falsey }
  #       end

  #       context 'when suject is from same core' do
  #         let(:subject_instance) { create(:production_unity_normal, group_id: current_user.id) }

  #         it { expect(subject.subject).to eq(subject_instance) }
  #       end
  #     end
  #   end
  # end
end
