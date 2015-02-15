(function(){
  var openFields = 0,
      partialFields = 1,
      closedFields = 2;

  var Field = function(){
    if ($('#controller-fields').length > 0) {
      this.init();
    }
  };

  Field.prototype.init = function() {
    var self = this;
    $('.js-set-all-fields-open').on('click', function(e) {
      e.preventDefault();

      var onSuccess = function(data) {
        $('.js-notices').hide();
        $('.js-all-open-notice').show();
        self.setAllIndicators(openFields);
      };  

      self.setFieldsAsOpen(openFields, onSuccess);
    });

    $('.js-set-all-fields-closed').on('click', function(e){
      e.preventDefault();

      var onSuccess = function(data) {
        $('.js-notices').hide();
        $('.js-all-closed-notice').show();
        self.setAllIndicators(closedFields);
      };

      self.setFieldsAsOpen(closedFields, onSuccess);
    });

    $('.js-set-all-fields-partially-closed').on('click', function(e){
      e.preventDefault();

      var onSuccess = function(data) {
        $('.js-notices').hide();
        $('.js-partially-closed-notice').show();
        self.setAllIndicators(partialFields);
      };

      self.setFieldsAsOpen(partialFields, onSuccess);
    });
  };

  Field.prototype.setFieldsAsOpen = function(statusNum, callback) {
    var request = $.ajax({
      url: "/fields/set_all",
      type: "POST",
      data: { statusNum : statusNum },
      dataType: 'json'
    });
     
    request.done(callback);
     
    request.fail(function( jqXHR, textStatus ) {
      alert( "Request failed: " + textStatus );
    });
  };

  Field.prototype.setAllIndicators = function(status) {

    $('.js-fields-table').find('.js-status-indicator').each(function(){
      console.log($(this));
      $(this).attr('data-status', status);
    });

  };

  var field = new Field();
}());