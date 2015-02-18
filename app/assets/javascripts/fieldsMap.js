(function(){

  var FieldMap = function(){
    this.init();
  };

  FieldMap.prototype.init = function() {
    console.log("Initing map");
    this.initMap();
    this.getFieldJson();
  };

  FieldMap.prototype.initMap = function() {
    console.log('initing map');
    var mapOptions = {
          center: { lat: 40.7278797, lng: -73.9719596},
          zoom: 11
        };

    this.map = new google.maps.Map(document.getElementById('map-canvas'), mapOptions);
    var transitLayer = new google.maps.TransitLayer();
    transitLayer.setMap(this.map);
    //google.maps.event.addDomListener(window, 'load', initialize);
  };

  FieldMap.prototype.addMarker = function(field) {
    // 40.7677135,-73.9749519,21
    // To add the marker to the map, use the 'map' property
    console.log(field);
    var myLatlng = new google.maps.LatLng(field.lat, field.long);
    var self = this;

    var marker = new google.maps.Marker({
        position: myLatlng,
        map: self.map,
        animation: google.maps.Animation.DROP
        // icon: image custom image
    });

    var infowindow = new google.maps.InfoWindow({
      content: field.name
    });
    infowindow.open(self.map, marker);

    google.maps.event.addListener(marker, 'click', function() {
      infowindow.open(self.map, marker);
    });
    // or marker.setMap(map);
  };

  FieldMap.prototype.addFieldsToView = function(fields) {
    var self = this;
    $(fields).each(function(){
      self.addMarker(this);
    });
  };

  FieldMap.prototype.getFieldJson = function() {
    var self = this;
    $.ajax({
      url: "/getfieldsjson",
      dataType: 'json'
    })
    .done(function( data ) {
      self.addFieldsToView(data);
    });
  };

  $(document).ready(function(){
    console.log('here');
    var fieldMap = new FieldMap();
  });
}());
