(function(){
  var openparks = 0,
    partialparks = 1,
    closedparks = 2;

  var ParkMap = function(){
        this.red = 'FD5961';
    this.yellow = 'CCCC00';
    this.green = '78B653';
    this.infoWindow = null;
    if ($('#map-canvas').length > 0)
    {
      this.init();
    }
  };

  ParkMap.prototype.init = function() {
    this.initMap();
    this.getparks();
  };

  ParkMap.prototype.initMap = function() {
    var mapOptions = {
          center: { lat: 40.7278797, lng: -73.9719596},
          zoom: 11
        };

    var windowHeight = $(window).height();
    $('#map-canvas').css('height', windowHeight);

    this.map = new google.maps.Map(document.getElementById('map-canvas'), mapOptions);
    var transitLayer = new google.maps.TransitLayer();
    transitLayer.setMap(this.map);
    //google.maps.event.addDomListener(window, 'load', initialize);
  };

  ParkMap.prototype.addMarker = function($park) {
    var self = this,
        lat = $park.data('lat'),
        long = $park.data('long'),
        parkStatus = parseInt($park.data('status')),
        count = $park.data('count');

    var myLatlng = new google.maps.LatLng(lat, long),
        self = this,
        iconColor = self.green;

    if (parkStatus == partialparks ) {
      iconColor = self.yellow;
    } else if (parkStatus == closedparks) {
      iconColor = self.red;
    } // no else needed it should default to green

    var mapMarker = 'http://chart.apis.google.com/chart?chst=d_map_pin_letter&chld=' + count + '|' + iconColor + '|000000';

    var marker = new google.maps.Marker({
        position: myLatlng,
        map: self.map,
        animation: google.maps.Animation.DROP,
        icon: mapMarker,
        itemCount: count
        // icon: image custom image
    });
    // add the new marker to the park
    var markerImg = $('<img>', {src: mapMarker});
    $park.find('.js-park-count').html(markerImg);



    google.maps.event.addListener(marker, 'click', function(event) {
      var name = $park.find('.park-item-name').html();
      // close any info windows the are already open
      if (self.infoWindow) {
        self.infoWindow.close();
      }

      self.infoWindow = new google.maps.InfoWindow({
        content: name
      });

      self.infoWindow.open(self.map, marker);

      self.map.panTo(marker.getPosition());
      var count = this.itemCount;
      // find the current item in the list and highlight it
      $('.js-park-item').removeClass('is-active');
      var $activepark = $('.js-park-item[data-count="' + this.itemCount + '"]');
      $activepark.addClass('is-active');

      // scroll to the active park
       $('.js-park-sidebar').animate({
        scrollTop: $activepark.offset().top
    }, 1000);
    });
  };

  ParkMap.prototype.addparksToView = function(parks) {
    var self = this;
    $(parks).each(function(){
      self.addMarker(this);
    });
  };

  ParkMap.prototype.getparks = function() {
    var parks = $('.js-park-item'),
      self = this;
    $.each(parks, function(){
      self.addMarker($(this));
    });
  };

  $(document).ready(function(){
    var parkMap = new ParkMap();
  });
}());
