class Tag < ActiveRecord::Base
  
  validates_presence_of :model_type
  validates_length_of   :name,  :within => 1..64
  
  has_many :tagships
end
