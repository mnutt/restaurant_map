require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/restaurants/show.html.erb" do
  include RestaurantsHelper
  
  before(:each) do
    assigns[:restaurant] = @restaurant = stub_model(Restaurant,
      :name => "value for name",
      :rating => "1",
      :latitude => "1.5",
      :longitude => "1.5",
      :review => "value for review",
    )
  end

  it "should render attributes in <p>" do
    render "/restaurants/show.html.erb"
    response.should have_text(/value\ for\ name/)
    response.should have_text(/1/)
    response.should have_text(/1\.5/)
    response.should have_text(/1\.5/)
    response.should have_text(/value\ for\ review/)
  end
end

