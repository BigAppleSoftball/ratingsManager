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

    $('.js-run-sync').click(function(){
      self.runPaymentsSync();
    });
  };

  PaymentsTracker.prototype.runPaymentsSync = function() {
    $('.js-loading-sync').show();
    
    var onSuccess = function(data){
      $('.js-loading-sync').hide();
      $('.js-latest-sync-time').html(data.sync_created_string);
      $('.js-update-count-badge').fadeIn().find('.js-update-count').html(data.players_updated_count);
      $('.js-scans-table tbody').prepend(data.scan_row_html);
    };

    var onError = function(data) {
      $('.js-loading-sync').hide();
      console.log('sync failed'. data);
    };

    var request = $.ajax({
      url: "/payments/sync",
      type: "GET",
      dataType: 'json'
    });
     
    request.done(onSuccess);
     
    request.fail(onError);
  };


  var paymentstracker = new PaymentsTracker();
}());