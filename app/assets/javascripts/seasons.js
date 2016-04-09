(function(){

  /**
   * @contrustor for selector that selected a season and populates 
   * other profiles with the right teams for the division
   */
  var DivisionSeasonSelector = function() {
    this.bindSeasonSelector();
  };

  /**
   * Bind the season division selector
   */
  DivisionSeasonSelector.prototype.bindSeasonSelector = function(){
    var self = this;
    $('.js-division-season-selector').on('change', function(){
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


  /*
   * Populate the team selector
   */
  DivisionSeasonSelector.prototype.populateTeamsSelect = function(divisions) {
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

  window.DivisionSeasonSelector = DivisionSeasonSelector;

}());