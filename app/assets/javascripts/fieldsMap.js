(function(){
  var openFields = 0,
    partialFields = 1,
    closedFields = 2;

  var FieldMap = function(){
        this.red = 'FD5961';
    this.yellow = 'CCCC00';
    this.green = '78B653';
    this.infoWindow = null;
    this.init();

  };

  FieldMap.prototype.init = function() {
    this.initMap();
    this.getFields();
  };

  FieldMap.prototype.initMap = function() {
    var mapOptions = {
          center: { lat: 40.7278797, lng: -73.9719596},
          zoom: 11
        };

    this.map = new google.maps.Map(document.getElementById('map-canvas'), mapOptions);
    var transitLayer = new google.maps.TransitLayer();
    transitLayer.setMap(this.map);
    //google.maps.event.addDomListener(window, 'load', initialize);
  };

  FieldMap.prototype.addMarker = function($field) {
    var self = this,
        lat = $field.data('lat'),
        long = $field.data('long'),
        fieldStatus = parseInt($field.data('status')),
        count = $field.data('count');

    var myLatlng = new google.maps.LatLng(lat, long),
        self = this,
        iconColor = self.green;

    if (fieldStatus == partialFields ) {
      iconColor = self.yellow;
    } else if (fieldStatus == closedFields) {
      iconColor = self.red;
    } // no else needed it should default to green

    var mapMarker = 'http://chart.apis.google.com/chart?chst=d_map_pin_letter&chld=' + count + '|' + iconColor + '|000000';

    var marker = new google.maps.Marker({
        position: myLatlng,
        map: self.map,
        animation: google.maps.Animation.DROP,
        icon: 'http://chart.apis.google.com/chart?chst=d_map_pin_letter&chld=' + count + '|' + iconColor + '|000000',
        itemCount: count
        // icon: image custom image
    });
    // add the new marker to the field
    var markerImg = $('<img>', {src: mapMarker});
    $field.find('.js-field-count').html(markerImg);



    google.maps.event.addListener(marker, 'click', function(event) {
      var name = $field.find('.field-item-name').html();
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
      $('.js-field-item').removeClass('is-active');
      var $activeField = $('.js-field-item[data-count="' + this.itemCount + '"]');
      $activeField.addClass('is-active');

      console.log($activeField.offset().top);
      // scroll to the active field
       $('.js-field-sidebar').animate({
        scrollTop: $activeField.offset().top
    }, 1000);
    });
  };

  FieldMap.prototype.addFieldsToView = function(fields) {
    var self = this;
    $(fields).each(function(){
      self.addMarker(this);
    });
  };

  FieldMap.prototype.getFields = function() {
    var fields = $('.js-field-item'),
      self = this;
    $.each(fields, function(){
      self.addMarker($(this));
    });
  };

  $(document).ready(function(){
    var fieldMap = new FieldMap();
  });
}());
