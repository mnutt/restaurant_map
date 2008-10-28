require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Restaurant do
  before(:each) do
    @valid_attributes = {
      :name => "value for name",
      :rating => "1",
      :latitude => "1.5",
      :longitude => "1.5",
      :review => "value for review",
      :last_visited_at => Time.now
    }
  end

  it "should create a new instance given valid attributes" do
    Restaurant.create!(@valid_attributes)
  end
end
