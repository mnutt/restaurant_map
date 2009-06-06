class Tag < ActiveRecord::Base
  
  validates_presence_of :model_type
  validates_length_of   :name,  :within => 1..64
  
  has_many :tagships

  # Enables special characters for tag names in an URL.
  def to_param
    "#{id}-#{name.downcase.gsub(/[^[:alnum:]]/, '-')}".gsub(/-{2,}/, '-')
  end
end
