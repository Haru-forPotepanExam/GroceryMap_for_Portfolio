class AddNameToUser < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :name, :string, nill: false
    add_index :users, :name, unique: true
  end
end
