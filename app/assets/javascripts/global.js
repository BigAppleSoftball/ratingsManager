(function(){

  /**
   * @constructor
   * Global javascript functions
   */
  var Global = function(){
    this.initTooltips();
    this.divSelector = new DivisionSelector();
    this.initMultiLevelDropdown();
    this.initBootstrapSwitcher();
  };

  /**
   * Intialize all js-tooltip with the bootstrap tooltip plugin
   */
  Global.prototype.initTooltips = function(){
    $('.js-tooltip').tooltip();
  };

  /**
   * Intializes the Bootstrap switch plugin to make checkboxes look like toggles
   * @return {[type]} [description]
   */
  Global.prototype.initBootstrapSwitcher = function() {
    $('.js-bs-switcher').bootstrapSwitch({
      onText: 'Yes',
      offText: 'No'
    });
  };

  Global.prototype.initMultiLevelDropdown = function() {
    $(".dropdown-menu > li > a.trigger").on("click",function(e){
      var current=$(this).next();
      var grandparent=$(this).parent().parent();
      if($(this).hasClass('left-caret')||$(this).hasClass('right-caret'))
        $(this).toggleClass('right-caret left-caret');
      grandparent.find('.left-caret').not(this).toggleClass('right-caret left-caret');
      grandparent.find(".sub-menu:visible").not(current).hide();
      current.toggle();
      e.stopPropagation();
    });

    $(".dropdown-menu > li > a:not(.trigger)").on("click",function(){
      var root=$(this).closest('.dropdown');
      root.find('.left-caret').toggleClass('right-caret left-caret');
      root.find('.sub-menu:visible').hide();
    });
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