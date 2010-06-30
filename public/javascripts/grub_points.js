var GrubPoints = {};

GrubPoints.showPopup = function(evt) {
  var size = new OpenLayers.Size(170,30);
  var loc = new OpenLayers.LonLat(this.restaurant.longitude, this.restaurant.latitude);

  var popup = new OpenLayers.Popup.FramedCloud("rm_" + this.restaurant.id, loc, size, this.restaurant.name, this.icon, true);

  popup.positionBlocks = {
    tl: {offset: new OpenLayers.Pixel(60, -7), padding: 0, blocks: [{size: 20}]},
    tr: {offset: new OpenLayers.Pixel(-60, -7), padding: 0, blocks: []},
    bl: {offset: new OpenLayers.Pixel(60, 12), padding: 0, blocks: []},
    br: {offset: new OpenLayers.Pixel(-60, 12), padding: 0, blocks: []}
  }

  $(this.icon.imageDiv).children().attr('src', '/images/OpenLayers/marker-small-blue.png');

  popup.calculateRelativePosition = function() {
    return "tr";
  }

  popup.updateBlocks = function() {
    $(this.div).addClass("pos_" + this.relativePosition);
  }

  popup._contentDivPadding.bottom = -4;
  popup._contentDivPadding.right = 0;
  markers.map.addPopup(popup, true);
};

GrubPoints.addRestaurantMarker = function(markers, restaurant, show) {
  var loc = new OpenLayers.LonLat(restaurant.longitude, restaurant.latitude);
  var marker = new OpenLayers.Marker(loc);
  marker.icon.url = '/images/OpenLayers/marker-small.png';
  marker.icon.size = {w: 12, h: 12};
  marker.restaurant = restaurant;
  markers.addMarker(marker);

  marker.events.register("mouseover", marker, GrubPoints.showPopup);
  marker.events.register("mouseout", marker, function(evt) {
    $(this.icon.imageDiv).children().attr('src', '/images/OpenLayers/marker-small.png');
  });
};