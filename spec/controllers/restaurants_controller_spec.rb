require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe RestaurantsController do

  def mock_restaurant(stubs={})
    @mock_restaurant ||= mock_model(Restaurant, stubs)
  end
  
  describe "responding to GET index" do

    it "should expose all restaurants as @restaurants" do
      Restaurant.should_receive(:find).with(:all).and_return([mock_restaurant])
      get :index
      assigns[:restaurants].should == [mock_restaurant]
    end

    describe "with mime type of xml" do
  
      it "should render all restaurants as xml" do
        request.env["HTTP_ACCEPT"] = "application/xml"
        Restaurant.should_receive(:find).with(:all).and_return(restaurants = mock("Array of Restaurants"))
        restaurants.should_receive(:to_xml).and_return("generated XML")
        get :index
        response.body.should == "generated XML"
      end
    
    end

  end

  describe "responding to GET show" do

    it "should expose the requested restaurant as @restaurant" do
      Restaurant.should_receive(:find).with("37").and_return(mock_restaurant)
      get :show, :id => "37"
      assigns[:restaurant].should equal(mock_restaurant)
    end
    
    describe "with mime type of xml" do

      it "should render the requested restaurant as xml" do
        request.env["HTTP_ACCEPT"] = "application/xml"
        Restaurant.should_receive(:find).with("37").and_return(mock_restaurant)
        mock_restaurant.should_receive(:to_xml).and_return("generated XML")
        get :show, :id => "37"
        response.body.should == "generated XML"
      end

    end
    
  end

  describe "responding to GET new" do
  
    it "should expose a new restaurant as @restaurant" do
      Restaurant.should_receive(:new).and_return(mock_restaurant)
      get :new
      assigns[:restaurant].should equal(mock_restaurant)
    end

  end

  describe "responding to GET edit" do
  
    it "should expose the requested restaurant as @restaurant" do
      Restaurant.should_receive(:find).with("37").and_return(mock_restaurant)
      get :edit, :id => "37"
      assigns[:restaurant].should equal(mock_restaurant)
    end

  end

  describe "responding to POST create" do

    describe "with valid params" do
      
      it "should expose a newly created restaurant as @restaurant" do
        Restaurant.should_receive(:new).with({'these' => 'params'}).and_return(mock_restaurant(:save => true))
        post :create, :restaurant => {:these => 'params'}
        assigns(:restaurant).should equal(mock_restaurant)
      end

      it "should redirect to the created restaurant" do
        Restaurant.stub!(:new).and_return(mock_restaurant(:save => true))
        post :create, :restaurant => {}
        response.should redirect_to(restaurant_url(mock_restaurant))
      end
      
    end
    
    describe "with invalid params" do

      it "should expose a newly created but unsaved restaurant as @restaurant" do
        Restaurant.stub!(:new).with({'these' => 'params'}).and_return(mock_restaurant(:save => false))
        post :create, :restaurant => {:these => 'params'}
        assigns(:restaurant).should equal(mock_restaurant)
      end

      it "should re-render the 'new' template" do
        Restaurant.stub!(:new).and_return(mock_restaurant(:save => false))
        post :create, :restaurant => {}
        response.should render_template('new')
      end
      
    end
    
  end

  describe "responding to PUT udpate" do

    describe "with valid params" do

      it "should update the requested restaurant" do
        Restaurant.should_receive(:find).with("37").and_return(mock_restaurant)
        mock_restaurant.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :restaurant => {:these => 'params'}
      end

      it "should expose the requested restaurant as @restaurant" do
        Restaurant.stub!(:find).and_return(mock_restaurant(:update_attributes => true))
        put :update, :id => "1"
        assigns(:restaurant).should equal(mock_restaurant)
      end

      it "should redirect to the restaurant" do
        Restaurant.stub!(:find).and_return(mock_restaurant(:update_attributes => true))
        put :update, :id => "1"
        response.should redirect_to(restaurant_url(mock_restaurant))
      end

    end
    
    describe "with invalid params" do

      it "should update the requested restaurant" do
        Restaurant.should_receive(:find).with("37").and_return(mock_restaurant)
        mock_restaurant.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :restaurant => {:these => 'params'}
      end

      it "should expose the restaurant as @restaurant" do
        Restaurant.stub!(:find).and_return(mock_restaurant(:update_attributes => false))
        put :update, :id => "1"
        assigns(:restaurant).should equal(mock_restaurant)
      end

      it "should re-render the 'edit' template" do
        Restaurant.stub!(:find).and_return(mock_restaurant(:update_attributes => false))
        put :update, :id => "1"
        response.should render_template('edit')
      end

    end

  end

  describe "responding to DELETE destroy" do

    it "should destroy the requested restaurant" do
      Restaurant.should_receive(:find).with("37").and_return(mock_restaurant)
      mock_restaurant.should_receive(:destroy)
      delete :destroy, :id => "37"
    end
  
    it "should redirect to the restaurants list" do
      Restaurant.stub!(:find).and_return(mock_restaurant(:destroy => true))
      delete :destroy, :id => "1"
      response.should redirect_to(restaurants_url)
    end

  end

end
