class StoresController < ApplicationController
  def show
    @place = Client.spot(params[:google_place_id], language: 'ja')
    @google_place_id = @place.place_id
    @store_name = @place.name
    @store = Store.find_or_initialize_by(google_place_id: params[:google_place_id])

    if user_signed_in?
      @current_evaluation = current_user.evaluations.find_by(google_place_id: @store.google_place_id)
    end

    if @store.evaluations.present?
      @store_average_evaluation = Evaluation.average_evaluation_label(@google_place_id)
    else
      @store_average_evaluation = "評価なし"
    end

    @categories = {
      '野菜' => Product.where(category_id: 1),
      '穀物' => Product.where(category_id: 2),
      '水産物' => Product.where(category_id: 3),
      '肉' => Product.where(category_id: 4),
      '卵・乳製品・大豆製品' => Product.where(category_id: 5),
      '果物' => Product.where(category_id: 6),
      '粉類' => Product.where(category_id: 7),
      'その他' => Product.where(category_id: 8),
    }.compact
  end
end
