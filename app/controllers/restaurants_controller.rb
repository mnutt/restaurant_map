require 'yelp'

class RestaurantsController < ApplicationController
  # GET /restaurants
  # GET /restaurants.xml
  def index
    @restaurants = Restaurant.find(:all, :order => "last_visited_at desc")

    @map = MapLayers::Map.new('map', :controls => []) do |map, page|
      page << map.add_layer(MapLayers::Layer::WMS.new("OpenStreetMap",
        [ "http://demo.opengeo.org/geoserver_openstreetmap/gwc/service/wms" ],
        {:layers => 'openstreetmap', :format => 'image/png'}))
      page << map.zoom_to_max_extent
      page << map.set_center(OpenLayers::LonLat.new(-73.9833, 40.7315), 14)
      page << map.add_control(Control::PanZoomBar.new)
      page << map.add_control(Control::Navigation.new(:document_drag => true))
    end

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @restaurants }
      format.json { render :json => @restaurants.map(&:attributes) }
    end
  end

  # GET /restaurants/1
  # GET /restaurants/1.xml
  def show
    @restaurant = Restaurant.find(params[:id])
    @map = MapLayers::Map.new('map', :controls => []) do |map, page|
      page << map.add_layer(MapLayers::Layer::WMS.new("OpenStreetMap",
        [ "http://demo.opengeo.org/geoserver_openstreetmap/gwc/service/wms" ],
        {:layers => 'openstreetmap', :format => 'image/png'}))
      page << map.zoom_to_max_extent
      page << map.set_center(OpenLayers::LonLat.new(@restaurant.longitude, @restaurant.latitude), 15)
      page << map.add_control(Control::PanZoomBar.new)
      page << map.add_control(Control::Navigation.new(:document_drag => true))
    end

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
