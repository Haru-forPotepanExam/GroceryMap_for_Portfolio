require 'rails_helper'

RSpec.describe "Home", type: :request do
  describe "GET /home" do
    let(:store) { create(:store, google_place_id: 'test123') }
    let(:invalid_store) { create(:store, google_place_id: 'invalid_id') }
    let!(:evaluation) { create(:evaluation, store: store, price_range: '安価', price_score: 1) }

    before do
      get root_path
    end

    it "レスポンスを返すこと" do
      expect(response).to have_http_status(200)
    end

    context '評価がある場合' do
      before do
        post '/home/index', params: { place_id: store.google_place_id }.to_json, headers: { 'Content-Type': 'application/json' }
      end
      it '平均の値を返すこと' do
        expect(response.body).to include('安価')
      end
    end

    context '評価がない場合' do
      before do
        post '/home/index', params: { place_id: invalid_store.google_place_id }.to_json,
                            headers: { 'Content-Type': 'application/json' }
      end
      it 'nilを返すこと' do
        expect(JSON.parse(response.body)).to eq({ 'evaluation' => nil })
      end
    end
  end
end
