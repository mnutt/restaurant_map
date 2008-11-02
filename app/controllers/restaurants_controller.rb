require 'yelp'

class RestaurantsController < ApplicationController
  # GET /restaurants
  # GET /restaurants.xml
  def index
    @restaurants = Restaurant.find(:all)

    @map = GMap.new("map_div")
    @map.control_init(:large_map => false,:map_type => true)
    @coords = []
    @restaurants.each do |restaurant|
      coord = [restaurant.latitude, restaurant.longitude]
      @coords << coord
      @map.overlay_init(GMarker.new(coord, :info_window => "<div class='rest'>#{restaurant.name}</div>"))
    end
    @map.center_zoom_on_points_init(*@coords)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @restaurants }
    end
  end

  # GET /restaurants/1
  # GET /restaurants/1.xml
  def show
    @restaurant = Restaurant.find(params[:id])
    @map = GMap.new("map_div")
    @map.control_init(:large_map => true,:map_type => true)
    
    coord = [@restaurant.latitude, @restaurant.longitude]
    @map.overlay_init(GMarker.new(coord, :info_window => @restaurant.name))
    @map.center_zoom_on_points_init(coord)

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @restaurant }
    end
  end

  # GET /restaurants/new
  # GET /restaurants/new.xml
  def new
    @map = GMap.new("map_div")
    @map.control_init(:large_map => true,:map_type => true)
    @map.center_zoom_init([40, -17], 5)
    @restaurant = Restaurant.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @restaurant }
    end
  end

  def find_restaurant
    @map = GMap.new("map_div")
    params[:restaurant] ||= {}
    params[:restaurant][:name] ||= "Spotted Pig"
    @zip = "10002"
    # @map = GMap.new("map_div")
    # @map.control_init(:large_map => true,:map_type => true)
    @coords = []

    client = Yelp::Client.new
    request = Yelp::Review::Request::Location.new(
                                                  :zipcode => "10002",
                                                  :radius => 5,
                                                  :term => params[:restaurant][:name],
                                                  :yws_id => YWS_ID)
    response = client.search(request)
    response['businesses'].each do |restaurant|
      coord = [restaurant['latitude'], restaurant['longitude']]
      @coords << coord
      @map.overlay_init(GMarker.new(coord,:info_window => "<div class='rest'>#{restaurant['name']}</div>"))
    end
    @restaurants = response['businesses']
    @map.center_zoom_init(@coords[0], 14)

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
