(function(){
  var openParks = 0,
      partialParks = 1,
      closedParks = 2;

  var Park= function(){
    if ($('#controller-parks').length > 0) {
      this.init();
    }
  };

  Park.prototype.init = function() {
    var self = this;
    $('.js-set-all-parks-open').on('click', function(e) {
      e.preventDefault();

      var onSuccess = function(data) {
        $('.js-notices').hide();
        $('.js-all-open-notice').show();
        self.setAllIndicators(openParks);
      };  

      self.setParksAsOpen(openParks, onSuccess);
    });

    $('.js-set-all-parks-closed').on('click', function(e){
      e.preventDefault();

      var onSuccess = function(data) {
        $('.js-notices').hide();
        $('.js-all-closed-notice').show();
        self.setAllIndicators(closedParks);
      };

      self.setParksAsOpen(closedParks, onSuccess);
    });

    $('.js-set-all-parks-partially-closed').on('click', function(e){
      e.preventDefault();

      var onSuccess = function(data) {
        $('.js-notices').hide();
        $('.js-partially-closed-notice').show();
        self.setAllIndicators(partialParks);
      };

      self.setParksAsOpen(partialParks, onSuccess);
    });
  };

  Park.prototype.setParksAsOpen = function(statusNum, callback) {
    var request = $.ajax({
      url: "/parks/set_all",
      type: "POST",
      data: { statusNum : statusNum },
      dataType: 'json'
    });
     
    request.done(callback);
     
    request.fail(function( jqXHR, textStatus ) {
      alert( "Request failed: " + textStatus );
    });
  };

  Park.prototype.setAllIndicators = function(status) {

    $('.js-parks-table').find('.js-status-indicator').each(function(){
      $(this).attr('data-status', status);
    });

  };

  var park = new Park();
}());