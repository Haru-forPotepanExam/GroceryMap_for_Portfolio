class StoresController < ApplicationController
  def index
    keyword = params[:keyword]
    lat = params[:lat].to_f
    lng = params[:lng].to_f

    stores = Store.where(google_place_id: Price.pluck(:google_place_id))
    place_ids = stores.pluck(:google_place_id)

    results = Store.near([lat, lng], 2).where(google_place_id: place_ids)

    render json: { valid_place_ids: results.pluck(:google_place_id) }
  end

  def show
    @store = Client.spot(params[:google_place_id], language: 'ja')
    @google_place_id = @store.place_id
    @store_name = @store.name
    @fav_store = Store.find_or_initialize_by(google_place_id: params[:google_place_id])

    @category1 = Product.where(category_id: 1)
    @category2 = Product.where(category_id: 2)
    @category3 = Product.where(category_id: 3)
    @category4 = Product.where(category_id: 4)
    @category5 = Product.where(category_id: 5)
    @category6 = Product.where(category_id: 6)
    @category7 = Product.where(category_id: 7)
    @category8 = Product.where(category_id: 8)
  end
end
