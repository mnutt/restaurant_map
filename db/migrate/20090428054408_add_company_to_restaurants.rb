class AddCompanyToRestaurants < ActiveRecord::Migration
  def self.up
    add_column :restaurants, :company, :string
  end

  def self.down
    remove_column :restaurants, :company
  end
end
