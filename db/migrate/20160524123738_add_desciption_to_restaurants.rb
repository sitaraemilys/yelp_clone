class AddDesciptionToRestaurants < ActiveRecord::Migration
  def change
    add_column :restaurants, :description, :text
  end
end
