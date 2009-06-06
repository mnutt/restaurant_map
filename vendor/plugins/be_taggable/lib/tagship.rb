class Tagship < ActiveRecord::Base

    belongs_to :model, :polymorphic => true
    belongs_to :tag,
               :counter_cache => "tagships_count"
end