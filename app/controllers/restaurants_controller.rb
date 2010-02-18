require 'yelp'

class RestaurantsController < ApplicationController
  # GET /restaurants
  # GET /restaurants.xml
  def index
    @restaurants = Restaurant.find(:all)

    @map = GoogleMap::Map.new
    @map.controls = [:large, :scale, :type]
    @map.zoom = 13
    @restaurants.each do |restaurant|
      @map.markers << GoogleMap::Marker.new(:lat => restaurant.latitude,
                                            :lng => restaurant.longitude,
                                            :map => @map,
                                            :html => "<div class='rest'>#{restaurant.name}</div>")
    end

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @restaurants }
    end
  end

  # GET /restaurants/1
  # GET /restaurants/1.xml
  def show
    @restaurant = Restaurant.find(params[:id])
    @map = GoogleMap::Map.new
    @map.controls = [:large, :scale, :type]
    @map.markers << GoogleMap::Marker.new(:lat => @restaurant.latitude,
                                          :lng => @restaurant.longitude,
                                          :map => @map,
                                          :html => @restaurant.name)

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @restaurant }
    end
  end

  # GET /restaurants/new
  # GET /restaurants/new.xml
  def new
    @map = GoogleMap::Map.new
    @map.controls = [:large, :scale, :type]
    @map.center = GoogleMap::Point.new(40, -17)
    @map.zoom = 5
    
    @restaurant = Restaurant.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @restaurant }
    end
  end

  def find_restaurant
    @map = GoogleMap::Map.new
    @zip = "10002"
    @marker_letters = ('a'..'z').to_a

    client = Yelp::Client.new
    location = {
      :zipcode => "10002",
      :radius => 5,
      :term => params[:name],
      :yws_id => YWS_ID
    }
    request = Yelp::Review::Request::Location.new(location)
    
    response = client.search(request)

    @restaurants = response['businesses'].first(10)
    @restaurants.each_with_index do |restaurant, i|
      marker_options = {
        :lat => restaurant['latitude'],
        :lng => restaurant['longitude'],
        :map => @map,
        :icon => GoogleMap::LetterIcon.new(@map, @marker_letters[i].upcase),
        :html => "<div class='rest'><b>#{restaurant['name']}</b><br/>#{restaurant['address1']}<br/>#{restaurant['city']}, #{restaurant['state']}</div>"
      }
      
      @map.markers << GoogleMap::Marker.new(marker_options)
    end
    

    render :layout => false
  end

  # GET /restaurants/1/edit
  def edit
    @restaurant = Restaurant.find(params[:id])
  end

  # POST /restaurants
  # POST /restaurants.xml
  def create
    @restaurant = Restaurant.new(params[:restaurant])

    respond_to do |format|
      if @restaurant.save
        flash[:notice] = 'Restaurant was successfully created.'
        format.html { redirect_to(@restaurant) }
        format.xml  { render :xml => @restaurant, :status => :created, :location => @restaurant }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @restaurant.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /restaurants/1
  # PUT /restaurants/1.xml
  def update
    @restaurant = Restaurant.find(params[:id])

    respond_to do |format|
      if @restaurant.update_attributes(params[:restaurant])
        flash[:notice] = 'Restaurant was successfully updated.'
        format.html { redirect_to(@restaurant) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @restaurant.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /restaurants/1
  # DELETE /restaurants/1.xml
  def destroy
    @restaurant = Restaurant.find(params[:id])
    @restaurant.destroy

    respond_to do |format|
      format.html { redirect_to(restaurants_url) }
      format.xml  { head :ok }
    end
  end
end
