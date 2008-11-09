class AddAddressToRestaurant < ActiveRecord::Migration
  def self.up
    add_column :restaurants, :address, :string
  end

  def self.down
    remove_column :restaurants, :address
  end
end
