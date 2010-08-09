class AddCollectionIdToRestaurants < ActiveRecord::Migration
  def self.up
    add_column :restaurants, :collection_id, :integer
  end

  def self.down
    remove_column :restaurants, :collection_id
  end
end
