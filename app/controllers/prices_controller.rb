class PricesController < ApplicationController
  def index
    @product = Product.find(params[:product_id])
    @product_prices = Price.where(product_id: @product.id).where(google_place_id: params[:store_google_place_id])
    @place = Client.spot(params[:store_google_place_id], language: 'ja')
  end

  def new
    @product = Product.find(params[:product_id])
    @place = Client.spot(params[:store_google_place_id], language: 'ja')
    @user = current_user
    @price = Price.new
    @google_place_id = params[:store_google_place_id]
  end

  def create
    @product = Product.find(price_params[:product_id])
    @user = current_user
    @price = Price.new(price_params)
    @google_place_id = params[:store_google_place_id]

    @place = Client.spot(params[:store_google_place_id], language: 'ja')
    @store = Store.find_or_initialize_by(google_place_id: @google_place_id)
    @store.assign_attributes(
      name: @place.name,
      address: @place.formatted_address,
      latitude: @place.lat,
      longitude: @place.lng
    )

    if @store.save
      @price = @store.prices.new(price_params)
      if @price.save
        flash[:notice] = "商品価格を投稿しました。"
        redirect_to store_prices_path(google_place_id: @store.google_place_id, product_id: @product.id)
      else
        flash[:notice] = "投稿に失敗しました。"
        render "new"
      end
    else
      flash[:alert] = "店舗情報の保存に失敗しました。"
      render "new"
    end
  end

  def edit
    @price = Price.find(params[:id])
    @store = Store.find_by(google_place_id: params[:google_place_id])
    @product = Product.find(params[:product_id])
  end

  def update
    @price = Price.find(params[:id])
    @store = Store.find(price_params[:google_place_id])
    @product = Product.find(price_params[:product_id])

    if @price.update(price_params)
      flash[:notice] = "価格情報を更新しました。"
      redirect_to own_prices_path
    else
      flash[:alert] = "価格情報の更新に失敗しました。"
      render "edit"
    end
  end

  def destroy
    Price.find(params[:id]).destroy
    flash[:notice] = "価格情報を削除しました。"
    redirect_to own_prices_path
  end

  def own_prices
    @prices = current_user.prices
  end

  def result
    @prices = @q.result.includes(:store)

    case params[:sort]
    when 'gram'
      @prices = @prices.sort_by { |price| price.prices_per_gram || Float::INFINITY }
    when 'quantity'
      @prices = @prices.sort_by { |price| price.prices_per_quantity || Float::INFINITY }
    when 'distance'
      if params[:lat].present? && params[:lng].present?
        user_lat = params[:lat].to_f
        user_lng = params[:lng].to_f

        @prices = @prices.sort_by do |price|
          store = price.store
          distance(user_lat, user_lng, store.latitude, store.longitude)
        end
      end
    end
    render :result
  end

  def own_result
    google_place_ids = current_user.favorites.pluck(:google_place_id)
    @own_q = Price.where(google_place_id: google_place_ids).ransack(params[:q])
    @prices = @own_q.result.includes(:store, :product).order(created_at: :desc).page(params[:page])

    case params[:sort]
    when 'gram'
      @prices = @prices.sort_by { |price| price.prices_per_gram || Float::INFINITY }
    when 'quantity'
      @prices = @prices.sort_by { |price| price.prices_per_quantity || Float::INFINITY }
    when 'distance'
      if params[:lat].present? && params[:lng].present?
        user_lat = params[:lat].to_f
        user_lng = params[:lng].to_f

        @prices = @prices.sort_by do |price|
          store = price.store
          distance(user_lat, user_lng, store.latitude, store.longitude)
        end
      end
    end
    render :own_result
  end

  private

  def price_params
    params.require(:price).permit(:price_value, :quantity, :weight, :product_id, :user_id, :google_place_id, :store_name, :memo)
  end

  def distance(lat1, lng1, lat2, lng2)
    x1 = lat1.to_f * Math::PI / 180
    y1 = lng1.to_f * Math::PI / 180
    x2 = lat2.to_f * Math::PI / 180
    y2 = lng2.to_f * Math::PI / 180

    radius = 6378.137
    diff_y = (y1 - y2).abs

    calc1 = Math.cos(x2) * Math.sin(diff_y)
    calc2 = Math.cos(x1) * Math.sin(x2) - Math.sin(x1) * Math.cos(x2) * Math.cos(diff_y)

    numerator = Math.sqrt(calc1**2 + calc2**2)
    denominator = Math.sin(x1) * Math.sin(x2) + Math.cos(x1) * Math.cos(x2) * Math.cos(diff_y)

    degree = Math.atan2(numerator, denominator)
    degree * radius
  end
end
