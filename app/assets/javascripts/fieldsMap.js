(function(){

  var FieldMap = function(){
    this.init();
  };

  FieldMap.prototype.init = function() {
    console.log("Initing map");
    this.initMap();
    this.addMarker();
  };

  FieldMap.prototype.initMap = function() {
    console.log('initing map');
    var mapOptions = {
          center: { lat: 40.7278797, lng: -73.9719596},
          zoom: 13
        };

    this.map = new google.maps.Map(document.getElementById('map-canvas'), mapOptions);
    //google.maps.event.addDomListener(window, 'load', initialize);
  };

  FieldMap.prototype.addMarker = function() {
    // 40.7677135,-73.9749519,21
    // To add the marker to the map, use the 'map' property
    var myLatlng = new google.maps.LatLng(40.7677135,-73.9749519);
    var self = this;
    var marker = new google.maps.Marker({
        position: myLatlng,
        map: self.map,
        animation: google.maps.Animation.DROP
        // icon: image custom image
    });
    // or marker.setMap(map);
  };

  FieldMap.prototype.getLatLongFromAddress = function() {

  };

  $(document).ready(function(){
    console.log('here');
    var fieldMap = new FieldMap();
  });
}());
