// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
(function(){

  var Team = function(){
    if ($('#controller-teams').length > 0) {
      this.$AddNewPlayerModal = $('.js-add-new-player-modal');
      this.$addPlayerForm = this.$AddNewPlayerModal.find('.js-player-form');
      this.init(); 
    }
  };

  Team.prototype.init = function() {
    this.bindAddNewPlayerModal();
    this.bindRosterActions();
  };

  /**
   * Binds actions to the Roster 
   */
  Team.prototype.bindRosterActions = function() {
    var onTeamPermissionsClick = function(e) {
      e.preventDefault();
      var $this = $(this),
          $rosterRow = $(this).closest('.js-roster-row'),
          rosterId = $rosterRow.data('roster-id'),
          queryData = {roster_id: rosterId};

      if ($this.data('is-make-manager')){
        queryData.set_manager = true;
      } else if ($this.data('is-make-rep')) {
        queryData.set_rep = true;
      } else if($this.data('is-remove-manager')) {
        queryData.remove_manager = true;
      } else if($this.data('is-remove-rep')) {
        queryData.remove_rep = true;
      }

      var updatedPermissions = function(data) {
        if(data.success) {
          if (data.html) {
            $.toaster({ priority : 'success', title : 'Success!', message : 'Roster Updated!'});
            $rosterRow.replaceWith(data.html);
          }
        } else if (data.error) {
          $.toaster({ priority : 'danger', title : 'Error!', message : data.error});
        }
      };

      var updatedPermissionsFailed = function(data){
        $.toaster({ priority : 'danger', title : 'Error!', message : 'Roster Not Updated, Please Refresh and try again.'});
      };

      $.ajax({
        dataType: 'JSON',
        url: '/rosters/update_permissions',
        postType: 'JSON',
        data: queryData,
        success: updatedPermissions,
        failure: updatedPermissionsFailed
      });
    };

    $('.js-team-roster-list').on('click', '.js-add-team-permissions', onTeamPermissionsClick);
  };

  Team.prototype.bindAddNewPlayerModal = function() {
    var self = this;
    var $playerForm = this.$AddNewPlayerModal.find('.js-player-form');
    this.bindPlayerFormListeners();

    $('.js-show-add-new-player-modal').on('click', function(){
      self.$AddNewPlayerModal.modal();
    });

    self.$AddNewPlayerModal.find('#roster_player_id').change(function(){
      var playerId = $(this).val();
          
      $.ajax({
        dataType: 'JSON',
        url: '/profiles/'+playerId,
        success: function(data){
          self.loadPlayerData(data);
        },
        failure: function(data){
          // TODO(paige) This needs to fail in a nice way
        }

      });
    });

    this.$AddNewPlayerModal.on('click', '.js-add-player-btn', function(e){
      e.preventDefault();
      var playerId = $('#roster_player_id').val(),
          teamId = $('#team_id').val();

      $('.js-player-save-errors').html('');
      $.ajax({
        dataType: 'JSON',
        type: 'POST',
        data: {
          profile_id: playerId,
          team_id: teamId
        },
        url: '/add_player_to_roster',
        success: function(data){
          if (data.errors) {
            $('.js-player-save-errors').show().html(data.errors);
          } else {
            $('.js-team-roster-list').append(data.profile_html);
            self.$AddNewPlayerModal.modal('hide');
            // TODO(paige) show a confirmation

          }
        }

      });
    });

    this.$AddNewPlayerModal.on('click', '.js-create-and-add-player-btn', function(e) {
      e.preventDefault();
    });

    this.$AddNewPlayerModal.on('click', '.js-clear-player-form', function(e){
      e.preventDefault();
      self.clearPlayerForm();
      // run ajax to create new player and add them to the roster
    });
  };

  /**
   * Clears the form and re enabled all the inputs
   */
  Team.prototype.clearPlayerForm = function() {
    this.$addPlayerForm.find('.js-player-first-name').removeAttr('disabled').val('');
    this.$addPlayerForm.find('.js-player-last-name').removeAttr('disabled').val('');
    this.$addPlayerForm.find('.js-player-email').removeAttr('disabled').val('');
    this.$addPlayerForm.find('.js-clear-player-form').attr('disabled', true);
    this.$addPlayerForm.find('.js-active-profile-notice').hide();
    this.$AddNewPlayerModal.find('.js-add-player-btn').attr('disabled', true);
  };

  Team.prototype.bindPlayerFormListeners = function() {
    var self = this;
    this.$addPlayerForm.find('.js-player-first-name').on('keydown paste', function(){
      self.checkEnableAddPlayerSubmit();
    });

    this.$addPlayerForm.find('.js-player-last-name').on('keydown paste', function(){
      self.checkEnableAddPlayerSubmit();
    });

    this.$addPlayerForm.find('.js-player-email').on('keydown paste', function(){
      self.checkEnableAddPlayerSubmit();
    });
  };

  Team.prototype.checkEnableAddPlayerSubmit = function() {
    if (this.checkValidPlayerInputs()) {
      $('.js-create-and-add-player-btn').removeAttr('disabled');
    }
  };

  /**
    * Just make sure player info has been added for now
    */
  Team.prototype.checkValidPlayerInputs = function() {
    var playerFirstName = this.$addPlayerForm.find('.js-player-first-name').val(),
        playerLastName = this.$addPlayerForm.find('.js-player-last-name').val(),
        playerEmail = this.$addPlayerForm.find('.js-player-email').val();

    return playerFirstName.length > 0 && playerLastName.length > 0 && playerEmail.length > 0;
  };

  /**
   * Load the Player Data into the modal form
   */ 
  Team.prototype.loadPlayerData = function(player) {
    this.$addPlayerForm.find('.js-player-first-name').attr('disabled', true).val(player.first_name);
    this.$addPlayerForm.find('.js-player-last-name').attr('disabled', true).val(player.last_name);
    this.$addPlayerForm.find('.js-player-email').attr('disabled', true).val(player.email);
    this.$addPlayerForm.find('.js-active-profile-notice').show();
    this.$addPlayerForm.find('.js-clear-player-form').removeAttr('disabled');
    this.$AddNewPlayerModal.find('.js-add-player-btn').removeAttr('disabled');

  };

  var team = new Team();
}());