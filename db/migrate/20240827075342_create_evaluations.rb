class CreateEvaluations < ActiveRecord::Migration[6.1]
  def change
    create_table :evaluations do |t|
      t.string :price_range
      t.references :user, null: false, foreign_key: true
      t.string :google_place_id, null: false

      t.timestamps
    end
    add_foreign_key :evaluations, :stores, column: :google_place_id, primary_key: :google_place_id
    add_index :evaluations, :google_place_id
  end
end
