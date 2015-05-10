// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
(function(window, document, undefined){

  var PlayerRatings = function(options) {
    this.initDialogActions();
    this.bindSaveBtn();
  };

  /**
   * Bind all the events btns to the right dialog
   */
  PlayerRatings.prototype.initDialogActions = function () {
    var self = this;
    $('.js-throwing-btn, .js-fielding-btn, .js-hitting-btn, .js-running-btn').on('click', function(){
      self.initDialog($(this));
    });
  };

  /**
   * Shows the right dialog with the right player stats based on the
   * button clicked by the user
   * @param  {jQueryObject} $clickedBtn the button clicked by the user
   */
  PlayerRatings.prototype.initDialog = function($clickedBtn) {
    var playerId = $clickedBtn.closest('.js-player-row').data('player-id'),
        currentPlayer = window.playersJson[playerId],
        $dialog = {},
        currentRatings = {};

    if ($clickedBtn.hasClass('js-throwing-btn')) {
      $dialog = $('.js-throwing-modal');
      currentRatings = currentPlayer.ratings.throwing;
    } else if ($clickedBtn.hasClass('js-fielding-btn')) {
      $dialog = $('.js-fielding-modal');
      currentRatings = currentPlayer.ratings.fielding;
    } else if ($clickedBtn.hasClass('js-hitting-btn')) {
      $dialog = $('.js-hitting-modal');
      currentRatings = currentPlayer.ratings.hitting;
    } else if ($clickedBtn.hasClass('js-running-btn')) {
      $dialog = $('.js-running-modal');
      currentRatings = currentPlayer.ratings.baserunning;
    }
    $dialog.data('player-id', playerId);
    this.setDialogCheckboxValues(currentRatings, $dialog);
    $dialog.modal();
  };

  /*
   * Set the Checkbox values based on the player hash values
   */
  PlayerRatings.prototype.setDialogCheckboxValues = function(ratings, $dialog) {
   $.each(ratings, function(key, value){
      if (value > 0) {
        $dialog.find("input[value='" + key + "']").prop('checked', true);
      } else {
        $dialog.find("input[value='" + key + "']").removeProp('checked');
      }
    });
  };

  /**
   * Bind save action
   */
  PlayerRatings.prototype.bindSaveBtn = function() {
    var self = this
    $('.js-save-close-btn').on('click', function(){
      // get the updating player id
      var $this = $(this),
          $modal = $this.closest('.modal'),
          playerId = $modal.data('player-id'),
          ratingType = $modal.data('rating-type'),
          requestData = {};;

      requestData.profileId = playerId;
      requestData.type = ratingType;

      // get the checkbox data
      var ratingsCheckboxes = $modal.find('.js-rating-checkbox'),
          ratingsData = {},
          totalChecked = 0;

      ratingsCheckboxes.each(function(){
        var $this = $(this);
        ratingsData['rating_' + $this.val()] = $this.is(':checked') ? 1 : 0;
        totalChecked += ratingsData['rating_' + $this.val()];
      });

      requestData.ratings = ratingsData;

      // run ajax to update the player
      $.ajax({
        method: "POST",
        dataType: 'JSON',
        url: "/ratings/update",
        data: {requestData}
      })
      .done(function(data) {
        // show toast
        if (data.success){
          $.toaster({ priority : 'success', title : 'Success!', message : 'Player Updated!'});
          // update the field with animation so the user noticed it
          var $btnValue = $(".js-player-row-" + playerId + " .js-" + ratingType + '-btn').find('.js-value'),
              $totalValue = $(".js-player-row-" + playerId + ' .js-total-btn').find('.js-value');
          self.updateAnimation($btnValue, totalChecked);
          self.updateAnimation($totalValue, data.rating_total);

          // update total
        } else if (data.errors.length > 0) {
          $.toaster({ priority : 'danger', title : 'Error!', message : 'Please Refresh and try again'});
        }
        $modal.modal('hide');
      });
    });
  };

  PlayerRatings.prototype.updateAnimation = function($element, newValue) {
    $element.slideUp({
      complete: function(){
        $element.html(newValue).slideDown();
      }
    });
  };

  PlayerRatings.prototype.saveChanges = function(playerId){
    // run ajax to update a playerratings
  };

  window.PlayerRatings = PlayerRatings;
}(window, document, undefined));