class ProductsController < ApplicationController
  def index
    @place = Client.spot(params[:google_place_id], language: 'ja')
    @google_place_id = @place.place_id
  end

  def new
    @product = Product.new
    session[:previous_url] = store_path(params[:store_google_place_id])
  end

  def create
    @product = Product.new(product_params)
    if @product.save
      flash[:notice] = "商品を追加しました。"
      redirect_to session[:previous_url]
    else
      flash[:alert] = "商品の追加に失敗しました。"
      render "new"
    end
  end

  private

  def product_params
    params.require(:product).permit(:name, :category_id)
  end
end
