require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/restaurants/new.html.erb" do
  include RestaurantsHelper
  
  before(:each) do
    assigns[:restaurant] = stub_model(Restaurant,
      :new_record? => true,
      :name => "value for name",
      :rating => "1",
      :latitude => "1.5",
      :longitude => "1.5",
      :review => "value for review",
    )
  end

  it "should render new form" do
    render "/restaurants/new.html.erb"
    
    response.should have_tag("form[action=?][method=post]", restaurants_path) do
      with_tag("input#restaurant_name[name=?]", "restaurant[name]")
      with_tag("input#restaurant_rating[name=?]", "restaurant[rating]")
      with_tag("input#restaurant_latitude[name=?]", "restaurant[latitude]")
      with_tag("input#restaurant_longitude[name=?]", "restaurant[longitude]")
      with_tag("textarea#restaurant_review[name=?]", "restaurant[review]")
    end
  end
end


