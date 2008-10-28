require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe RestaurantsController do
  describe "route generation" do
    it "should map #index" do
      route_for(:controller => "restaurants", :action => "index").should == "/restaurants"
    end
  
    it "should map #new" do
      route_for(:controller => "restaurants", :action => "new").should == "/restaurants/new"
    end
  
    it "should map #show" do
      route_for(:controller => "restaurants", :action => "show", :id => 1).should == "/restaurants/1"
    end
  
    it "should map #edit" do
      route_for(:controller => "restaurants", :action => "edit", :id => 1).should == "/restaurants/1/edit"
    end
  
    it "should map #update" do
      route_for(:controller => "restaurants", :action => "update", :id => 1).should == "/restaurants/1"
    end
  
    it "should map #destroy" do
      route_for(:controller => "restaurants", :action => "destroy", :id => 1).should == "/restaurants/1"
    end
  end

  describe "route recognition" do
    it "should generate params for #index" do
      params_from(:get, "/restaurants").should == {:controller => "restaurants", :action => "index"}
    end
  
    it "should generate params for #new" do
      params_from(:get, "/restaurants/new").should == {:controller => "restaurants", :action => "new"}
    end
  
    it "should generate params for #create" do
      params_from(:post, "/restaurants").should == {:controller => "restaurants", :action => "create"}
    end
  
    it "should generate params for #show" do
      params_from(:get, "/restaurants/1").should == {:controller => "restaurants", :action => "show", :id => "1"}
    end
  
    it "should generate params for #edit" do
      params_from(:get, "/restaurants/1/edit").should == {:controller => "restaurants", :action => "edit", :id => "1"}
    end
  
    it "should generate params for #update" do
      params_from(:put, "/restaurants/1").should == {:controller => "restaurants", :action => "update", :id => "1"}
    end
  
    it "should generate params for #destroy" do
      params_from(:delete, "/restaurants/1").should == {:controller => "restaurants", :action => "destroy", :id => "1"}
    end
  end
end
