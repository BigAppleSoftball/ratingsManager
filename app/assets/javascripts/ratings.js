// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
(function(window, document, undefined){

  var PlayerRatings = function () {
    this.initDialogActions();
    this.bindSaveBtn();
    this.bindCreateNewPlayer();
    this.bindRowActions();
  };

  /**
   * Bind all the events btns to the right dialog
   */
  PlayerRatings.prototype.initDialogActions = function () {
    var self = this;
    $('.js-ratings-table').on('click', '.js-throwing-btn, .js-fielding-btn, .js-hitting-btn, .js-baserunning-btn', function(){
      self.resetModal();
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
    } else if ($clickedBtn.hasClass('js-baserunning-btn')) {
      $dialog = $('.js-baserunning-modal');
      currentRatings = currentPlayer.ratings.baserunning;
    } else {
      return;
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
      var $checkbox = $dialog.find("input[value='" + key + "']");
      if (value > 0) {
        //$checkbox.prop('checked', true);
        $checkbox.bootstrapSwitch('state', true, true);
      } else {
        //$checkbox.removeProp('checked');
        $checkbox.bootstrapSwitch('state', false, true);
      }
    });
  };

  /**
   * Bind save action
   */
  PlayerRatings.prototype.bindSaveBtn = function() {
    var self = this;
    $('.js-save-close-btn').on('click', function() {
      // get the updating player id
      var $this = $(this),
          $modal = $this.closest('.modal'),
          playerId = $modal.data('player-id'),
          ratingType = $modal.data('rating-type'),
          requestData = {};

      self.resetModal();
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

      var onPlayerUpdated = function(data) {
        // show toast
        if (data.errors) {
          self.showError();
          var error_string = "";
          $(data.errors).each(function(){
            var error_item = this;
            $.each(error_item, function(){
              error_string += this;
            });         
          });
          $('.js-' + ratingType + '-modal-error').html(error_string).fadeIn();
        } else if (data.success && data.ratings && data.type){
          $.toaster({ priority : 'success', title : 'Success!', message : 'Player Updated!'});
          // update the field with animation so the user noticed it
          var $btnValue = $(".js-player-row-" + playerId + " .js-" + ratingType + '-btn').find('.js-value'),
              $totalValue = $(".js-player-row-" + playerId + ' .js-total-btn').find('.js-value');
          self.updateAnimation($btnValue, totalChecked);
          self.updateAnimation($totalValue, data.rating_total);
          window.playersJson[data.profile_id].ratings[data.type] = data.ratings;
          // update total
          $modal.modal('hide');
        }
      }; 

      // run ajax to update the player
      $.ajax({
        method: "POST",
        dataType: 'JSON',
        url: "/ratings/update",
        data: requestData,
        success: onPlayerUpdated
      });
    });
  };

  /**
   * Uses Slideup animation to replace html on a given element
   * @param  {jQueryObject} $element the element to replace
   * @param  {String} newValue the new value to replace
   * @param  {boolean} shouldReplace Whether or not you adding the new html to the $element or completely replacing it
   */
  PlayerRatings.prototype.updateAnimation = function($element, newValue, shouldReplace) {
    $element.slideUp({
      complete: function(){
        if (shouldReplace) {
           $element.replaceWith(newValue).slideDown();
        } else {
          $element.html(newValue).slideDown();
        }
      }
    });
  };

  /**
   * Uses fade animation to replace html on a given element
   * @param  {jQueryObject} $element the element to replace
   * @param  {String} newValue the new value to replace
   * @param  {boolean} shouldReplace Whether or not you adding the new html to the $element or completely replacing it
   */
  PlayerRatings.prototype.fadeAnimation = function($element, newValue, shouldReplace) {
    $element.fadeOut({
      complete: function(){
        if (shouldReplace) {
           $element.replaceWith(newValue).fadeIn();
        } else {
          $element.html(newValue).slideDown();
        }
      }
    });
  };

  /*
   * Remove error messages.
   */
  PlayerRatings.prototype.resetModal = function() {
    $('.js-modal-error').hide().html('');
  };

  /**
   * Creates a new empty ranking for a given profileid
   */
  PlayerRatings.prototype.bindCreateNewPlayer = function() {
    var self = this;
    $('.js-add-player-ranking').on('click', function(e){
      e.preventDefault();

      var $button = $(this),
          $playerRow = $button.closest('.js-player-row'),
          playerId = $playerRow.data('player-id'),
          requestData = {};

      if (playerId) {
        // run ajax to update the player
        requestData.profileId = playerId;

        var onRatingCreated = function(data) {
          if (data.success && data.rating_row_html) {
            // add player json to the windows json
            if (!data.profile_id || !data.ratings) {
              self.showError();
            } else {
              self.fadeAnimation($('.js-player-row-' + data.profile_id), data.rating_row_html, true); 
              window.playersJson[data.profile_id] = {};
               window.playersJson[data.profile_id]['ratings'] = data.ratings;
              $.toaster({ priority : 'success', title : 'Success!', message : 'Player Updated, Start Adding Ratings!!'});
            }
          }
        };

        $.ajax({
          method: 'POST',
          dataType: 'JSON',
          url: '/ratings/new',
          data: requestData,
          success: onRatingCreated
        });
      } else {
        self.showError();
      }
    });
  };

  /**
   * Shows an Error Message Toast
   */
  PlayerRatings.prototype.showError = function () {
    $.toaster({ priority : 'danger', title : 'Error!', message : 'Could not update information'});
  };

  /**
   * Bind the Approve and Reject Actions on
   * a ASANA Rating Row
   */
  PlayerRatings.prototype.bindRowActions = function() {
    var $ratingRow = $('.js-rating-row'),
        self = this;

    $ratingRow.on('click', '.js-approve-rating', function(){
      var ratingId = $(this).closest('.js-rating-row').data('asana-rating-id');
      self.runApproveOrRejectRating(ratingId, true);
    });

    $ratingRow.on('click', '.js-reject-rating', function(){
      var ratingId = $(this).closest('.js-rating-row').data('asana-rating-id');
      self.runApproveOrRejectRating(ratingId, false);
    });
  };

  /**
   * Run the Ajax Call to Reject or approve the rating
   * @param  {integer}  ratingId  Asana rating id
   * @param  {Boolean} isApproved whether or not to approve a rating
   */
  PlayerRatings.prototype.runApproveOrRejectRating = function(ratingId, isApproved) {
    var self = this;
    $.ajax({
      url: '/teams/asana/update',
      type: 'POST',
      data: {
        isApproved: isApproved,
        ratingId: ratingId
      },
      success: self.onApproveRejectSuccess,
      failure: self.onApproveRejectFailure
    })
  };

  PlayerRatings.prototype.onApproveRejectSuccess = function(data) {
    var $ratingRow = $('.js-rating-row-' + data.ratingId);
    if (data.isApproved === 'true') {
      $ratingRow.removeClass('danger info is-rejected is-pending');
      $ratingRow.addClass('success is-approved');
    } else {
      $ratingRow.removeClass('success info is-pending is-approved');
      $ratingRow.addClass('danger is-rejected');
    }
  };

  PlayerRatings.prototype.onApproveRejectFailure = function(data) {
  };

  window.PlayerRatings = PlayerRatings;
}(window, document, undefined));