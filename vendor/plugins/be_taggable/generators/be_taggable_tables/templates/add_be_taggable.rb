class AddBeTaggable < ActiveRecord::Migration
  def self.up
    create_table :tags do |t|
      t.column :name,           :string, :limit => 64
      t.column :model_type,     :string
      t.column :tagships_count, :integer, :default => 0
      t.column :created_at,     :datetime
      t.column :updated_at,     :datetime
    end
    add_index :tags, [:name]
    add_index :tags, [:name, :model_type]

    create_table :tagships do |t|
      t.column :model_id,       :integer, :default => 0
      t.column :model_type,     :string
      t.column :tag_id,         :integer, :default => 0
      t.column :created_at,     :datetime
    end
    add_index :tagships, [:model_id, :model_type]
    add_index :tagships, [:tag_id]

    # "--- []" is empty array in yaml format
    <% models.each{|model|  table = model.constantize.table_name  %>
    add_column <%= table.to_sym %>, :tags_cache, :string, :default => "--- []"
    ActiveRecord::Base.connection.update("UPDATE <%= table %> SET tags_cache = '--- []'")
    <% } %>
  end

  def self.down
    <% models.each{|model| %>
    remove_column <%= model.constantize.table_name.to_sym %>, :tags_cache
    <% } -%>
    
    drop_table :tagships
    drop_table :tags
  end
end
