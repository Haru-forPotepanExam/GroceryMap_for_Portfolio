class EvaluationsController < ApplicationController
  def create
    @google_place_id = params[:store_google_place_id]
    @store_data = Client.spot(@google_place_id, language: 'ja')
    @store = Store.find_or_initialize_by(google_place_id: @google_place_id)
    @store.assign_attributes(
      name: @store_data.name,
      address: @store_data.formatted_address,
      latitude: @store_data.lat,
      longitude: @store_data.lng
    )

    if @store.save
      @evaluation = current_user.evaluations.find_by(google_place_id: @store.google_place_id)
      price_range = params[:price_range]
      price_score = Evaluation.price_value_to_score(price_range)

      if @evaluation
        if @evaluation.price_range == params[:price_range]
          @evaluation.destroy
        else
          @evaluation.update(price_range: price_range, price_score: price_score)
        end
      else
        current_user.evaluations.create(
          price_range: price_range,
          price_score: price_score,
          google_place_id: @store.google_place_id
        )
      end
      redirect_to store_path(@store)
    else
      flash[:alert] = "評価の保存に失敗しました。"
      redirect_to store_path(@store)
    end
  end

  def destroy
    @store = Store.find(params[:store_google_place_id])
    @evaluation = current_user.evaluations.find_by(google_place_id: @store.google_place_id)
    @evaluation.destroy
    redirect_to store_path(@store)
  end
end
