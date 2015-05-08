// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
(function(window, document, undefined){
  console.log('here');

  var PlayerRatings = function(options) {
    this.initDialogs();
  };

  /**
   * Bind all the events btns to the right dialog
   */
  PlayerRatings.prototype.initDialogs = function () {
    var self = this;
    $('.js-throwing-btn').on('click', function(){
      var $this = $(this);
          playerId = $this.closest('.js-player-row').data('player-id'),
          currentPlayer = window.playersJson[playerId],
          $dialog = $('.js-throwing-modal');

      self.setDialogCheckboxValues(currentPlayer.ratings.throwing, $dialog);
      $dialog.modal();
    });

    $('.js-fielding-btn').on('click', function(){
      var $this = $(this);
        playerId = $this.closest('.js-player-row').data('player-id'),
        currentPlayer = window.playersJson[playerId],
        $dialog = $('.js-fielding-modal');

      self.setDialogCheckboxValues(currentPlayer.ratings.fielding, $dialog);
      $dialog.modal();
    });

    $('.js-hitting-btn').on('click', function(){
      var $this = $(this);
        playerId = $this.closest('.js-player-row').data('player-id'),
        currentPlayer = window.playersJson[playerId],
        $dialog = $('.js-hitting-modal');

      self.setDialogCheckboxValues(currentPlayer.ratings.hitting, $dialog);
      $dialog.modal();
    });

    $('.js-running-btn').on('click', function(){
      var $this = $(this);
        playerId = $this.closest('.js-player-row').data('player-id'),
        currentPlayer = window.playersJson[playerId],
        $dialog = $('.js-running-modal');
      //window.playersJson[4].ratings.throwing[1]
      self.setDialogCheckboxValues(currentPlayer.ratings.baserunning, $dialog);
      $dialog.modal();
    });
  };

  /*
   * Set the Checkbox values based on the player hash values
   * TODO we need to change this
   */
  PlayerRatings.prototype.setDialogCheckboxValues = function(ratings, $dialog) {
    console.log(ratings);
   $.each(ratings, function(key, value){
      if (value > 0) {
        $dialog.find("input[value='" + key + "']").prop('checked', true);
      } else {
        $dialog.find("input[value='" + key + "']").removeProp('checked');
      }
    });
  };

  window.PlayerRatings = PlayerRatings;
}(window, document, undefined));