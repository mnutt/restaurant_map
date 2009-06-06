class TagsController < ApplicationController
  def show
    @tag = Tag.find_by_name(params[:id])
    @restaurants = Restaurant.find_tagged_with(params[:id])

        @map = GMap.new("map_div")
    @map.control_init(:large_map => true,:map_type => true, :width => 800, :height => 500)
    @coords = []
    @restaurants.each do |restaurant|
      coord = [restaurant.latitude, restaurant.longitude]
      @coords << coord
      @map.overlay_init(GMarker.new(coord, :info_window => "<div class='rest'>#{restaurant.name}</div>"))
    end
    @map.center_zoom_on_points_init(*@coords)
  end

  def index
    @tags = Restaurant.tags_count.sort
  end
end
