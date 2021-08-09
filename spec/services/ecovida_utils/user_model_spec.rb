require 'rails_helper'

RSpec.describe EcovidaUtils::UserModel, type: :service do
  context 'execute' do
    subject { described_class.execute(user_type, object_id) }
    let(:admin) { create(:admin) }
    let(:core) { create(:core) }
    let(:group) { create(:group) }

    context 'when admin' do
      let(:user_type) { 4 }
      let(:object_id) { admin.id }

      it { expect(subject).to eq(admin) }
    end

    context 'when core' do
      let(:user_type) { 3 }
      let(:object_id) { core.id }

      it { expect(subject).to eq(core) }
    end

    context 'when group' do
      let(:user_type) { 2 }
      let(:object_id) { core.id }

      it { expect(subject).to eq(core) }
    end
  end
end
