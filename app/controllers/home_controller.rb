class HomeController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:index]
  def index
    if request.post?
      place_id = params[:place_id]
      store = Store.find_by(google_place_id: place_id)
      if store.evaluations.present?
        @evaluation = Evaluation.average_evaluation_label(store.google_place_id)
      else
        @evaluation = nil
      end
      render json: { evaluation: @evaluation }
    end
  end
end
