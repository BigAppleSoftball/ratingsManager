// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
(function(){

  var TeamsSponsors = function(){
    if ($('#controller-teams_sponsors')){
      this.init();
    }
  };

  TeamsSponsors.prototype.init = function() {
    var divisionSelector = new window.DivisionSeasonSelector();
  };

  var teamsSponsors = new TeamsSponsors();
}());