class StoresController < ApplicationController
  def show
    @place = Client.spot(params[:google_place_id], language: 'ja')
    @google_place_id = @place.place_id
    @store_name = @place.name
    @store = Store.find_or_initialize_by(google_place_id: params[:google_place_id])
    @current_evaluation = current_user.evaluations.find_by(google_place_id: @store.google_place_id)

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
