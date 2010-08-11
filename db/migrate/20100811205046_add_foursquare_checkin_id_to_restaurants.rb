class AddFoursquareCheckinIdToRestaurants < ActiveRecord::Migration
  def self.up
    add_column :restaurants, :foursquare_checkin_id, :integer
  end

  def self.down
    remove_column :restaurants, :foursquare_checkin_id
  end
end
