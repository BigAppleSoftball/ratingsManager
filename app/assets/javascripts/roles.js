(function(){
  var Roles = function() {
    if ($('#controller-roles').length > 0) {
      this.init();
    }
  };

  Roles.prototype.init = function() {
    this.bindRemovePermissions();
    this.bindAddPermission();
    this.bindRemoveRole();
    this.bindAddRole();
  };

  /**
   * Bind Delete button action
   */
  Roles.prototype.bindRemovePermissions = function() {
    var self = this;

    $('.js-role-permissions').on('click', '.js-remove-role-permission', function(e) {
      e.preventDefault();
      var $this = $(this),
          permissionId = $this.data('permission-id'),
          roleId = $this.data('role-id');

      $.ajax({
        data: {
          role_id: roleId,
          permission_id: permissionId
        },
        type: 'DELETE',
        url: '/remove_permission_from_role',
        success: self.onRemovePermissionSuccess,
        error : self.onRemovePermissionFailure
      });
    });
  };

  /**
   * Bind Add Permission Action
   */
  Roles.prototype.bindAddPermission = function() {
    var self = this;

    $('.js-add-new-permission').on('click', function() {
      var $this = $(this),
          permissionId = $('.js-add-permission-select').val(),
          roleId = $('.js-role-id').val();

      $.ajax({
        data: {
          role_id: roleId,
          permission_id: permissionId
        },
        dataType: 'json',
        type: 'POST',
        url: '/add_permission_to_role',
        success: self.onAddPermissionSuccess,
        error : self.onAddPermissionFailure
      });
    });
  };

  /**
   * Bind Action for when User Clicks the Remove Role Button
   */
  Roles.prototype.bindRemoveRole = function() {
    var self = this;

    $('.js-role-profiles').on('click', '.js-remove-role-profile', function(e) {
      e.preventDefault();

      var $this = $(this),
          profileId = $this.data('profile-id'),
          roleId = $this.data('role-id');

      // send ajax call to remove profile
      $.ajax({
        data: {
          role_id: roleId,
          profile_id: profileId
        },
        dataType: 'json',
        type: 'DELETE',
        url: '/remove_profile_from_role',
        success: self.onRemoveProfileSuccess,
        error : self.onRemoveProfileFailure
      });
    });
  };

  Roles.prototype.bindAddRole = function() {
    var self = this;
    $('.js-add-role-profile').on('click', function() {
      var $this = $(this),
          profileId = $('.js-add-profile-select').val(),
          roleId = $('.js-role-id').val();

      // send ajax call to remove profile
      $.ajax({
        data: {
          role_id: roleId,
          profile_id: profileId
        },
        dataType: 'json',
        type: 'POST',
        url: '/add_profile_to_role',
        success: self.onAddProfileSuccess,
        error : self.onAddProfileFailure
      });
    });
  };

  /**
   * Action when a Permission remove ajax call 
   * returns success from server
   */
  Roles.prototype.onRemovePermissionSuccess = function(data) {
    if (data && data.success) {
      // remove the role from the view
      $('.js-role-permission-' + data.role_id + '-' + data.permission_id).closest('.js-role-permission-item').slideUp();
    } else {
      this.onRemovePermissionFailure(data);
    }
  };

  Roles.prototype.onRemovePermissionFailure = function(data) {
    $.toaster({ priority : 'danger', title : 'Error!', message : 'Issue Removing Permission!'});
  };

  Roles.prototype.onAddPermissionSuccess =function(data) {
    if (data && data.success) {
      $.toaster({ priority : 'success', title : 'Success!', message : 'Permission Added!!'});
      $('.js-role-permissions').append(data.html);
    } else {
      $.toaster({ priority : 'danger', title : 'Error!', message : 'Issue Adding Permission ' + data.message});
    }
  };

  Roles.prototype.onAddPermissionFailure = function(data) {
   $.toaster({ priority : 'danger', title : 'Error!', message : 'Issue Adding Permission ' + data.message});
  };

  Roles.prototype.onRemoveProfileSuccess = function(data) {
      if (data && data.success) {
      $('.js-role-profile-' + data.role_id + '-' + data.profile_id).closest('.js-role-profile-item').slideUp();
    } else {
      $.toaster({ priority : 'danger', title : 'Error!', message : 'Issue Adding Permission ' + data.message});
    }
  };

  Roles.prototype.onRemoveProfileFailure = function(data) {
    // show toast notifcation on failure
   $.toaster({ priority : 'danger', title : 'Error!', message : 'Issue Removing Profile: ' + data.message});
  };

  Roles.prototype.onAddProfileSuccess = function(data) {
    console.log("ADDING PROFILE", data);
    if (data && data.success) {
      $.toaster({ priority : 'success', title : 'Success!', message : 'New Profile Added!!'});
      $('.js-role-profiles').append(data.html);
    } else {
      $.toaster({ priority : 'danger', title : 'Error!', message : 'Issue Adding Profile: ' + data.message});
    }
  };

  Roles.prototype.onAddProfileFailure = function(data) {
    $.toaster({ priority : 'danger', title : 'Error!', message : 'Issue Adding Profile: ' + data.message});
  };

  new Roles();
}());

