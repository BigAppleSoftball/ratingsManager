// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
//controller-games
(function(){

  var Game = function(){
    this.$container = $('#controller-games');
    if (this.$container.length > 0) {
      this.init();
    }
  };

  Game.prototype.init = function() {
    this.bindSeasonSelector();
  };

  /**
   * Add listener to season selector change
   */
  Game.prototype.bindSeasonSelector = function() {
    var self = this;
    $('.js-season-selector').on('change', function(){
      console.log("season change");
      console.log($(this).val());

      // run ajax call to update the teams selector with only season teams 
      $.ajax({
        url: '/teams_by_season',
        data: {
          season_id: $(this).val()
        },
        success: function(data) {
          self.populateTeamsSelect(data);
        }
      });
    });
  };

  Game.prototype.populateTeamsSelect = function(divisions) {
    var $selectData = $('<select>');
    $selectData.append('<option></option>');
    $.each(divisions, function(){
      var $divisionGroup = $('<optgroup>', {label: this.name});
      $.each(this.teams, function(){
        var $option = $('<option>', {value: this.id, text: this.name});
        $divisionGroup.append($option);
      });
      $selectData.append($divisionGroup)
    });
    $('.js-teams-selector').html($selectData.html()).trigger("chosen:updated");;
  };

  var game = new Game();

}());