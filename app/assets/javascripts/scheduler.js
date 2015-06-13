// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
(function(){

  /**
   * @contrustor for selector that selected a season and populates 
   * other profiles with the right teams for the division
   */
  var Scheduler = function() {
    if ($('#controller-schedules').length > 0) {
      this.init();
    }
  };

  Scheduler.prototype.init = function(){
    this.bindGeneratorRun();
  };

  /**
   * bind button to run ajax and grab data
   */
  Scheduler.prototype.bindGeneratorRun = function() {
    var self = this;
    $('.js-scheduler-generator').on('click', function(e){
      e.preventDefault();
      // get total games
      var totalGames = $('.js-total-games').val();
      // get division id
      var divisionId = $('.js-division-id').val();
      // get has doubleheaders boolean
      self.runGenerator(divisionId, totalGames);

    });
  };

  Scheduler.prototype.runGenerator = function(divisionId, totalGames) {
    var $results = $('.js-scheduler-results');
    console.log('running generator');
    $.ajax({
      dataType: 'JSON',
      url: '/scheduler/run',
      data: {
        'divisionId': divisionId,
        'totalGames': totalGames
      },
      success: function(data) {
        $.toaster({ priority : 'success', title : 'Success!', message : 'Schedule generated!'});
        $results.hide().html(data.results_html).fadeIn('slow');
      },
      error: function(data) {
        $.toaster({ priority : 'danger', title : 'Error!', message : 'Something went wrong!'});
      }
    });
  };


  var scheduler = new Scheduler();

}());