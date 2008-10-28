class CreateRestaurants < ActiveRecord::Migration
  def self.up
    create_table :restaurants do |t|
      t.string :name
      t.integer :rating
      t.float :latitude
      t.float :longitude
      t.text :review
      t.datetime :last_visited_at

      t.timestamps
    end
  end

  def self.down
    drop_table :restaurants
  end
end
