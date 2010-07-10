class TagsController < ApplicationController
  def show
    @tag = Tag.find_by_name(params[:id])
    @restaurants = Restaurant.find_tagged_with(params[:id])

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
      format.html
      format.xml  { render :xml => @restaurants }
      format.json { render :json => @restaurants.map(&:attributes) }
    end
  end

  def index
    @tags = Restaurant.tags_count.sort
  end
end
