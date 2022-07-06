require 'rails_helper'

RSpec.describe Idea, type: :model do
  describe '#valid?' do
    subject { instance.valid? }
    let(:instance) { create(:idea) }

    context '正常時' do
      it { is_expected.to eq true }
    end

    context '異常時' do
      context 'category_idがnil' do
        before { instance.category_id = nil }

        it { is_expected.to eq false }
      end

      context 'bodyがnil' do
        before { instance.body = nil }

        it { is_expected.to eq false }
      end
    end
  end
end
