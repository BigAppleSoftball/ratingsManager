(function(){

  /**
   * @constructor
   * Global javascript functions
   */
  var Global = function(){
    this.initTooltips();
    this.divSelector = new DivisionSelector();
  };

  /**
   * Intialize all js-tooltip with the bootstrap tooltip plugin
   */
  Global.prototype.initTooltips = function(){
    $('.js-tooltip').tooltip();
  };

  var DivisionSelector = function() {
    this.init();
  };

  DivisionSelector.prototype.init = function() {
    this.bindActions();
  };

  DivisionSelector.prototype.bindActions = function() {
    $('.js-division-season-selector').bind('change', function(){
      var $this = $(this),
          seasonId = $this.val();

      $.ajax({
        url: '/get_divisions_by_season',
        data: {
          'season_id': seasonId
        },
        success: function(data) {
          var $selector = $('.js-division-selector');
          if (data.html) {
            $selector.html(data.html);
            $selector.chosen().trigger("chosen:updated");
          } else {
            // TODO (paige)
            // do something if something when wrong
          }
        },
        error: function(data) {
          // TODO(paige) show an error
        }
      });
    });
  };

  var global = new Global();

}());