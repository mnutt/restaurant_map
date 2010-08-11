require 'yelp'

class RestaurantsController < ApplicationController
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
      format.json { render :json => @restaurants.map(&:attributes) }
    end
  end

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
  end

  def new
    @map = GoogleMap::Map.new
    @map.controls = [:large, :scale, :type]
    @map.center = GoogleMap::Point.new(40, -17)
    @map.zoom = 5

    @restaurant = Restaurant.new
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

  def edit
    @restaurant = Restaurant.find(params[:id])
  end

  def create
    @collection = current_user.collections.find params[:restaurant][:collection_id]
    @restaurant = @collection.restaurants.new(params[:restaurant])

    respond_to do |format|
      if @restaurant.save
        format.html {
          flash[:notice] = 'Restaurant was successfully created.'
          redirect_to edit_collection_url(@collection)
        }
        format.js { render :partial => 'restaurants/edit_restaurant', :object => @restaurant }
      else
        format.js { render :status => 422, :nothing => true }
        render :action => "new"
      end
    end
  end

  def update
    @collection = current_user.collections.find params[:restaurant][:collection_id]
    @restaurant = @collection.restaurants.find(params[:id])

    if @restaurant.update_attributes(params[:restaurant])
      flash[:notice] = 'Restaurant was successfully updated.'
      redirect_to(@restaurant)
    else
      render :action => "edit"
    end
  end

  def destroy
    @restaurant = Restaurant.find(params[:id])
    @restaurant.destroy

    respond_to do |format|
      format.html { redirect_to(restaurants_url) }
      format.xml  { head :ok }
    end
  end
end
