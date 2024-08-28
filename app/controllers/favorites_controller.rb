class FavoritesController < ApplicationController
  def index
    @favorites = current_user.favorites
    @places = @favorites.map do |fav|
      Client.spot(fav.google_place_id, language: 'ja')
    end
  end

  def create
    @store = Store.find_or_initialize_by(google_place_id: params[:store_google_place_id])
    if @store.save
      @favorite = current_user.favorites.new(google_place_id: @store.google_place_id)
      if @favorite.save
        redirect_to store_path(@store)
      end
    end
  end

  def destroy
    @store = Store.find(params[:store_google_place_id])
    @favorite = current_user.favorites.find_by(google_place_id: @store.google_place_id)
    @favorite.destroy
    redirect_to store_path(@store)
  end
end
