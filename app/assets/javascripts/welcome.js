(function(window, document, undefined){
  var Welcome = function(options) {
    this.options = $.extend(true, {}, this.defaults, options);
    var $container = $('#team-welcome-panel');
    if ($container.length > 0) {
      this.initDialogs();
    }
    this.bindLoginFormSubmit();
  };

  /**
   * init
   * @return {Object} URL parameters
   */
  Welcome.prototype.initDialogs = function () {
    var self = this;
    $('.js-throwing-btn').on('click', function(){
      var $this = $(this);
          playerId = $this.closest('.js-player-row').data('playerid'),
          currentPlayer = window.playersJson[playerId],
          $dialog = $('.js-throwing-modal');

      self.setDialogCheckboxValues(currentPlayer.throwing.ratings, $dialog);
      $dialog.modal();
    });

    $('.js-fielding-btn').on('click', function(){
      var $this = $(this);
        playerId = $this.closest('.js-player-row').data('playerid'),
        currentPlayer = window.playersJson[playerId],
        $dialog = $('.js-fielding-modal');

      self.setDialogCheckboxValues(currentPlayer.fielding.ratings, $dialog);
      $dialog.modal();
    });


    $('.js-hitting-btn').on('click', function(){
      var $this = $(this);
        playerId = $this.closest('.js-player-row').data('playerid'),
        currentPlayer = window.playersJson[playerId],
        $dialog = $('.js-hitting-modal');

      self.setDialogCheckboxValues(currentPlayer.hitting.ratings, $dialog);
      $dialog.modal();
    });

    $('.js-running-btn').on('click', function(){
      var $this = $(this);
        playerId = $this.closest('.js-player-row').data('playerid'),
        currentPlayer = window.playersJson[playerId],
        $dialog = $('.js-running-modal');

      self.setDialogCheckboxValues(currentPlayer.running.ratings, $dialog);
      $dialog.modal();
    });
  };

  Welcome.prototype.setDialogCheckboxValues = function(ratings, $dialog) {
   $.each(ratings, function(key, value){
      if (value > 0) {
        $dialog.find("input[value='" + key + "']").prop('checked', true);
      } else {
        $dialog.find("input[value='" + key + "']").removeProp('checked');
      }
    });
  };

  Welcome.prototype.bindLoginFormSubmit = function(){
    var self = this;
    $('.js-login-form').submit(function(e) {
      e.preventDefault();
      var $this = $(this);
      var formData = self.validateForm($this),
          $errorMessage = $('.js-login-form-error');

      $errorMessage.hide();

      if (formData.error) {
        $errorMessage.show().html(errorMessage);
        return;
      }

      $.ajax({
          type: "POST",
          url: '/teamsnaplogin',
          data: formData.data})
        .done(function(data) {
          if (data.failed) {
            $errorMessage.show().html('Teamsnap Login Failed: ' + data.message);
            return;
          } else if (data.success) {
            $this.fadeOut();
            $errorMessage.removeClass('alert-danger').addClass('alert-success').show().html('Successfully Logged In! Loading your teams! (this may take a while)');
            window.location.href = "/";
          }
        })
        .fail(function(data){
      });
    });
  };

  /**
   * validates the login data and shows a form if true
   */
  Welcome.prototype.validateForm = function($form) {
    var formData = $form.serializeArray(),
        formObj = {},
        errorMessage = '',
        response = {};

    $.each(formData, function(){
      var name = this.name,
          value = this.value;

      if (name) {
        formObj[name] = value;
      }

      if (!value) {
        errorMessage += ' Please enter a ' + name;
      }
    });
    response.error = errorMessage;
    response.data = formObj;
    return response;
  };

  $(document).ready(function() {
    var welcome = new Welcome();
  });

})(window, document);