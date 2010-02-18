class TagsController < ApplicationController
  def show
    @tag = Tag.find_by_name(params[:id])
    @restaurants = Restaurant.find_tagged_with(params[:id])

    @map = GoogleMap::Map.new
    @map.controls = [:large, :scale, :type]

    @restaurants.each do |restaurant|
      marker_options = {
        :lat => restaurant.latitude,
        :lng => restaurant.longitude,
        :map => @map,
        :html => "<div class='rest'>#{restaurant.name}</div>"
      }
      @map.markers << GoogleMap::Marker.new(marker_options)
    end
  end

  def index
    @tags = Restaurant.tags_count.sort
  end
end
