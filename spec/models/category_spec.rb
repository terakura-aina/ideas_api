require 'rails_helper'

RSpec.describe Category, type: :model do
  describe '#valid?' do
    subject { instance.valid? }
    let(:instance) { build(:category) }

    context '正常時' do
      it { is_expected.to eq true }
    end

    context '異常時' do
      context 'nameがnil' do
        before { instance.name = nil }

        it { is_expected.to eq false }
      end

      context 'nameが既に存在している' do
        let!(:other_instance) { create(:category) }

        it { is_expected.to eq false }
      end
    end
  end
end
