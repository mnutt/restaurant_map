class Restaurant < ActiveRecord::Base
  be_taggable

  belongs_to :collection

  def self.new_from_foursquare(checkin)
    new(:name => checkin.venue.name,
        :address => checkin.venue.address,
        :longitude => checkin.venue.geolong,
        :latitude => checkin.venue.geolat,
        :last_visited_at => Time.parse(checkin.created),
        :foursquare_checkin_id => checkin.id)
  end
end
