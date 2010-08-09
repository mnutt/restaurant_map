class Restaurant < ActiveRecord::Base
  be_taggable

  belongs_to :collection
end
