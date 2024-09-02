require 'rails_helper'

RSpec.describe Evaluation, type: :model do
  let(:user) { create(:user) }
  let(:store) { create(:store, google_place_id: 'test123') }
  let(:invalid_store) { create(:store, google_place_id: 'invalid_store_id') }
  let!(:evaluation1) { create(:evaluation, user: user, store: store, price_range: '安価', price_score: 1) }
  let!(:evaluation2) { create(:evaluation, user: user, store: store, price_range: 'やや安価', price_score: 2) }
  let!(:evaluation3) { create(:evaluation, user: user, store: store, price_range: '平均', price_score: 3) }

  describe 'average_evaluation' do
    it 'average evaluationが正しく機能すること' do
      expect(Evaluation.average_evaluation(store.google_place_id)).to eq(2)
    end

    it '評価がない場合0を返すこと' do
      expect(Evaluation.average_evaluation(invalid_store.google_place_id)).to eq(0)
    end
  end

  describe 'average_evaluation_label' do
    it '正しい値を返すこと' do
      expect(Evaluation.average_evaluation_label(store.google_place_id)).to eq('やや安価')
    end

    it '1から5ではない場合評価なしを返すこと' do
      expect(Evaluation.average_evaluation_label(invalid_store.google_place_id)).to eq('評価なし')
    end
  end
end
