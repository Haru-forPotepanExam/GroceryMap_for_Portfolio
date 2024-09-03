require 'rails_helper'

RSpec.describe "Stores::Shows", type: :system do
  let(:user) { create(:user) }
  let(:store) { create(:store) }
  let(:mock_store) do
    OpenStruct.new(place_id: store.google_place_id, name: store.name, formatted_address: "123 Tokyo St",
                   opening_hours: { 'weekday_text' => ["Monday: 9:00 AM – 9:00 PM"] })
  end
  let!(:evaluation) { create(:evaluation, store: store, price_range: "安価", price_score: 1) }
  let!(:evaluation2) { create(:evaluation, store: store, price_range: "やや安価", price_score: 2) }
  let!(:evaluation3) { create(:evaluation, store: store, price_range: "平均", price_score: 3) }
  let!(:categories) do
    (1..8).map { |i| create(:category, id: i, name: "category#{i}") }
  end
  let!(:product1) { create(:product, name: "キャベツ", category: categories.first) }
  let!(:product2) { create(:product, name: "シリアル", category: categories.second) }
  let!(:vegetable_price) do
    create(:price, product: product1, price_value: 100, google_place_id: store.google_place_id, user: user)
  end

  before do
    sign_in user
    allow(Client).to receive(:spot).and_return(mock_store)
    visit store_path(store)
  end

  it "ストア情報が表示されていること" do
    expect(page).to have_content(mock_store.name)
    expect(page).to have_content(mock_store.formatted_address)
    expect(page).to have_content(mock_store.formatted_phone_number)
    expect(page).to have_content("Monday: 9:00 AM – 9:00 PM")
  end

  it "お気に入りボタンが表示されていること" do
    expect(page).to have_css(".fav_btn")
  end

  it "パーシャルが正常に表示されていること" do
    expect(page).to have_css(".product_container")
  end

  it "平均評価が表示されること" do
    within(".average_evaluation") do
      expect(page).to have_content("平均")
    end
  end

  it "評価ができること" do
    within(".evaluate_btn") do
      click_button "安価"
      expect(page).to have_css(".evaluated")
    end
  end

  it '検索結果のみではなくすべての商品が表示されていること', js: true do
    within(".product_search_container") do
      fill_in 'product-search-box', with: 'キャベツ'
      click_button '検索'
    end

    expect(page).to have_content('キャベツ')
    expect(page).to have_content('シリアル')
  end

  it '該当商品がない場合、メッセージが表示されること', js: true do
    within(".product_search_container") do
      fill_in 'product-search-box', with: 'not_applicable_product'
      click_button '検索'
    end
    expect(page).to have_content('該当の商品は存在しません。')
    expect(page).to have_content('キャベツ')
    expect(page).to have_content('シリアル')
  end

  it "商品一覧が表示されていること" do
    within first(".category_items") do
      expect(page).to have_content("キャベツ")
      expect(page).not_to have_content("シリアル")
    end
  end

  it "価格情報がない場合のメッセージが表示されること" do
    vegetable_price.destroy
    visit store_path(google_place_id: store.google_place_id)

    within first(".category_items") do
      expect(page).to have_content("価格情報なし")
    end
  end

  it "ページトップに戻るリンクが表示されていること" do
    expect(page).to have_link("ページトップに戻る", href: "#product_top")
  end

  it "商品価格を確認するリンクをクリックして正しいページに遷移すること" do
    within first('.product_each_item') do
      click_link "商品価格を確認する"
    end

    expect(page).to have_current_path(store_prices_path(store_google_place_id: store.google_place_id,
                                                        product_id: product1.id))
  end

  it "商品価格を投稿するリンクをクリックして正しいページに遷移すること" do
    within first('.product_each_item') do
      click_link "商品価格を投稿する"
    end

    expect(page).to have_current_path(new_store_price_path(store_google_place_id: store.google_place_id,
                                                           product_id: product1.id))
  end

  it "商品を追加するリンクをクリックして正しいページに遷移すること" do
    click_link "商品を追加する"
    expect(page).to have_current_path(new_product_path(store_google_place_id: store.google_place_id))
  end
end
