require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/restaurants/index.html.erb" do
  include RestaurantsHelper
  
  before(:each) do
    assigns[:restaurants] = [
      stub_model(Restaurant,
        :name => "value for name",
        :rating => "1",
        :latitude => "1.5",
        :longitude => "1.5",
        :review => "value for review",
      ),
      stub_model(Restaurant,
        :name => "value for name",
        :rating => "1",
        :latitude => "1.5",
        :longitude => "1.5",
        :review => "value for review",
      )
    ]
  end

  it "should render list of restaurants" do
    render "/restaurants/index.html.erb"
    response.should have_tag("tr>td", "value for name", 2)
    response.should have_tag("tr>td", "1", 2)
    response.should have_tag("tr>td", "1.5", 2)
    response.should have_tag("tr>td", "1.5", 2)
    response.should have_tag("tr>td", "value for review", 2)
  end
end

