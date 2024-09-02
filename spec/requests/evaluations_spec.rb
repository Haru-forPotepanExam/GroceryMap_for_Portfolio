require 'rails_helper'

RSpec.describe "Evaluations", type: :request do
  let(:user) { create(:user) }
  let(:store) { create(:store, google_place_id: 'test123', name: 'Test Store', address: '123 Test St') }
  let(:evaluation) { create(:evaluation, user: user, store: store, price_range: '安価', price_score: 1) }

  before do
    sign_in user
    allow(Client).to receive(:spot).and_return(
      double(
        name: 'Test Store',
        formatted_address: '123 Test St',
        lat: 35.6895,
        lng: 139.6917
      )
    )
  end

  describe "POST /evaluations" do
    before do
      post store_evaluations_path(store.google_place_id)
    end

    it 'リクエストが成功すること' do
      expect(response).to have_http_status(302)
    end

    context "評価が新規作成される場合" do
      before do
        post store_evaluations_path(store.google_place_id), params: {
          price_range: 'やや安価',
        }
      end

      it "評価を作成し、ストアページにリダイレクトすること" do
        expect(response).to redirect_to(store_path(store))
        expect(Evaluation.last.price_range).to eq('やや安価')
      end
    end

    context "評価が更新される場合" do
      before do
        evaluation
        post store_evaluations_path(store.google_place_id), params: {
          price_range: '平均',
        }
      end

      it "既存の評価を更新し、ストアページにリダイレクトすること" do
        expect(response).to redirect_to(store_path(store))
        expect(evaluation.reload.price_range).to eq('平均')
      end
    end

    context "同じ評価が再度クリックされた場合" do
      before do
        evaluation
        post store_evaluations_path(store.google_place_id), params: {
          price_range: '安価',
        }
      end

      it "評価が削除され、ストアページにリダイレクトすること" do
        expect(response).to redirect_to(store_path(store))
        expect(Evaluation.find_by(id: evaluation.id)).to be_nil
      end
    end
  end

  describe "DELETE /evaluations/:id" do
    before do
      evaluation
      delete store_evaluations_path(store.google_place_id, evaluation)
    end

    it "評価を削除し、ストアページにリダイレクトすること" do
      expect(response).to redirect_to(store_path(store))
      expect(Evaluation.find_by(id: evaluation.id)).to be_nil
    end
  end
end
