class AddPriceScoreToEvaluations < ActiveRecord::Migration[6.1]
  def change
    add_column :evaluations, :price_score, :integer
  end
end
