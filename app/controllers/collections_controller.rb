class CollectionsController < ApplicationController

  def show
    @collection = Collection.find params[:id]
    @restaurants = @collection.restaurants

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

  def edit
    @collection = current_user.collections.find params[:id]
  end

  def update
    @collection = current_user.collections.find params[:id]

    if @collection.update_attributes(params[:collection])
      redirect_to collection_url(@collection)
    else
      render 'edit'
    end
  end

  def create
    @collection = current_user.collections.build(params[:collection])

    if @collection.save
      redirect_to collection_url(@collection)
    else
      render 'new'
    end
  end

  def new
    @collection = Collection.new
  end

end
