// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
//controller-games
(function(){

  var Game = function(){
    this.$container = $('#controller-games');
    if (this.$container.length > 0) {
      this.init();

      if ($('.js-games-attendance-panel').length > 0) {
        this.attendancePanel = new AttendancePanel($('.js-games-attendance-panel'));
      }
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

  /**
   * @constructor
   * The Attendance panel for the game page 
   */
  var AttendancePanel = function($container) {
    this.$container = $container;
    this.init();
  };

  /**
   * intialize the attendance panel
   */
  AttendancePanel.prototype.init = function(){
    this.bindActions();
  }

  /**
   * Bind button listeners
   */
  AttendancePanel.prototype.bindActions = function(){
    this.$container.find('.js-attendance-btn').on('click', function() {
      var $this = $(this),
          $row = $this.closest('.js-player-row'),
          profile_id = $row.data('profile-id'),
          game_id = $row.data('game-id');

      if ($this.hasClass('is-yes')) {
        // player is attending game
        is_attending = true;
        $row.addClass('is-attending').removeClass('is-not-attending');
      } else {
        // player isn't attending game
        is_attending = false;
        $row.removeClass('is-attending').addClass('is-not-attending');
      }

      // run ajax to update players attendance
      $.ajax({
        url: '/set_attendance',
        type: 'post',
        dataType: 'JSON',
        data: {
          'is_attending': is_attending,
          'profile_id': profile_id,
          'game_id': game_id
        },
        success: function(data) {
          // TODO(paige) show an error if it failed to save
        },
        error: function() {
          // TODO (paige) show an error if it failed to save
        }
      })
    });
  };

  var game = new Game();

}());