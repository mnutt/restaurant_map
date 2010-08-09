class CreateCollections < ActiveRecord::Migration
  def self.up
    create_table :collections do |t|
      t.integer :user_id
      t.string :name
      t.boolean :public
      t.string :private_token

      t.timestamps
    end
  end

  def self.down
    drop_table :collections
  end
end
