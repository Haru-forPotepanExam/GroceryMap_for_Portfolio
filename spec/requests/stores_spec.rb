require 'rails_helper'

RSpec.describe "Stores", type: :request do
  let(:user) { create(:user) }
  let(:store) { create(:store) }
  let(:mock_store) do
    OpenStruct.new(place_id: store.google_place_id, name: "Mock Store", formatted_address: "123 Tokyo St",
                   opening_hours: { 'weekday_text' => ["Monday: 9:00 AM – 9:00 PM"] })
  end
  let!(:categories) do
    (1..8).map { |i| create(:category, id: i, name: "Category #{i}") }
  end
  let!(:products) do
    (1..8).map { |i| create(:product, id: i, name: "Product #{i}") }
  end
  let!(:evaluation) do
    create(:evaluation, store: store, google_place_id: store.google_place_id)
  end

  describe "GET /show" do
    before do
      sign_in user
      allow(Client).to receive(:spot).and_return(mock_store)
      get store_path(google_place_id: store.google_place_id)
    end

    it "レスポンスを返すこと" do
      expect(response).to have_http_status(200)
    end

    it "パラメーターに一致する店舗情報が取得できていること" do
      expect(response.body).to include(mock_store.name)
    end

    it "category_id1の商品が取得できていること" do
      expect(response.body).to include("Product 1")
    end

    it "category_id2の商品が取得できていること" do
      expect(response.body).to include("Product 2")
    end

    it "category_id3の商品が取得できていること" do
      expect(response.body).to include("Product 3")
    end

    it "category_id4の商品が取得できていること" do
      expect(response.body).to include("Product 4")
    end

    it "category_id5の商品が取得できていること" do
      expect(response.body).to include("Product 5")
    end

    it "category_id6の商品が取得できていること" do
      expect(response.body).to include("Product 6")
    end

    it "category_id7の商品が取得できていること" do
      expect(response.body).to include("Product 7")
    end

    it "category_id8の商品が取得できていること" do
      expect(response.body).to include("Product 8")
    end

    it "評価が存在する場合、平均評価が取得できていること" do
      expect(response.body).to include("平均")
    end

    context "評価が存在しない場合" do
      before do
        evaluation.destroy
        get store_path(google_place_id: store.google_place_id)
      end

      it "評価が存在しない場合、'評価なし'と表示されること" do
        expect(response.body).to include("評価なし")
      end
    end
  end
end
