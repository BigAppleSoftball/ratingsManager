(function(){

  var PaymentsTracker = function(){
    if ($('#controller-payments_tracker').length > 0) {
      this.init();
    }
  };

  PaymentsTracker.prototype.init = function() {
    this.bindEvents();
  };

  PaymentsTracker.prototype.bindEvents = function() {
    var self = this;

    $('.js-send-teamsnap-player-update').click(function(){
      self.sendTeamsnapUpdate();
    });
  };

  PaymentsTracker.prototype.sendTeamsnapUpdate = function() {
    var onSuccess = function(data){
      console.log('Player Updated!');
    };

    var onError = function(data) {
      console.log('player not updated');
    };

    var request = $.ajax({
      url: "/teamsnap/updateplayer",
      type: "GET",
      data: {},
      dataType: 'json'
    });
     
    request.done(onSuccess);
     
    request.fail(onError);
  };


  var paymentstracker = new PaymentsTracker();
}());