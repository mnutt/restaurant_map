class Collection < ActiveRecord::Base
  belongs_to :user
  has_many :restaurants, :order => 'created_at DESC'
end
