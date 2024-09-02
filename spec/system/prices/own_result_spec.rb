require 'rails_helper'

RSpec.describe "Prices::OwnResults", type: :system do
  let(:user) { create(:user) }
  let(:other_store) { create(:store) }
  let(:favorite_store) { create(:store, latitude: 35.6900, longitude: 139.6920) }
  let(:favorite_store2) { create(:store, latitude: 35.6885, longitude: 139.6912) }
  let(:category) { create(:category) }
  let!(:product) { create(:product, category: category) }
  let!(:favorite) { create(:favorite, google_place_id: favorite_store.google_place_id, user_id: user.id) }
  let!(:favorite2) { create(:favorite, google_place_id: favorite_store2.google_place_id, user_id: user.id) }
  let!(:price1) do
    create(:price, google_place_id: favorite_store.google_place_id, product_id: product.id, price_value: 1000, memo: "memo",
                   user: user, weight: 100, quantity: "")
  end
  let!(:price2) do
    create(:price, google_place_id: favorite_store2.google_place_id, product_id: product.id, price_value: 900, weight: 200,
                   quantity: 1, user: user)
  end
  let!(:price3) do
    create(:price, google_place_id: favorite_store2.google_place_id, product_id: product.id, price_value: 800, weight: "",
                   quantity: 3, user: user)
  end
  let!(:price4) do
    create(:price, google_place_id: other_store.google_place_id, product_id: product.id, price_value: 2000, user: user)
  end

  before do
    sign_in user
    visit own_prices_result_prices_path
  end

  it "お気に入り店舗の検索結果が正しく表示されること" do
    within(".table_container") do
      fill_in "q_product_name_or_memo_cont", with: "memo"
      click_button "検索"
    end

    expect(page).to have_content(product.name)
    expect(page).to have_content("1000円")
    expect(page).to have_content("memo")
  end

  it "価格情報が存在しない場合、メッセージが表示されること" do
    price1.destroy
    visit own_prices_result_prices_path

    within(".table_container") do
      fill_in "q_product_name_or_memo_cont", with: "memo"
      click_button "検索"
    end

    expect(page).to have_content("価格情報は投稿されていません")
  end

  it "価格順（g）選択時に適切に並び替えられること" do
    within(".table_container") do
      fill_in "q_product_name_or_memo_cont", with: "#{product.name}"
      click_button "検索"
    end
    within(".sort_options") do
      click_link "価格順（g）"
    end

    within first('tbody tr') do
      expect(page).to have_content(price2.price_value.to_s)
    end
  end

  it "価格順（個数）選択時に適切に並び替えられること" do
    within(".table_container") do
      fill_in "q_product_name_or_memo_cont", with: "#{product.name}"
      click_button "検索"
    end
    within(".sort_options") do
      click_link "価格順（個数）"
    end

    within first('tbody tr') do
      expect(page).to have_content(price3.price_value.to_s)
    end
  end

  it "距離順選択時に適切に並び替えられること", js: true do
    within(".table_container") do
      fill_in "q_product_name_or_memo_cont", with: "#{product.name}"
      click_button "検索"
    end

    page.execute_script("navigator.geolocation.getCurrentPosition = function(success) {
      var position = { coords: { latitude: 35.6895, longitude: 139.6917 } };
      success(position);
    };")

    within(".sort_options") do
      click_link "距離順"
    end

    expect(page).to have_current_path(/sort=distance/)

    within first('tbody tr') do
      expect(page).to have_content(price1.price_value.to_s)
    end
  end

  it "お気に入りしていない店舗の価格情報が表示されないこと" do
    expect(page).not_to have_content(price4.price_value.to_s)
  end
end
