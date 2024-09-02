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
end
