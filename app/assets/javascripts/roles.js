(function(){
  var Roles = function() {
    if ($('#controller-roles').length > 0) {
      this.init();
    }
  };

  Roles.prototype.init = function() {
    this.bindRemovePermissions();
    this.bindAddPermission();
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




  // initialize the Role (why did I start doing this? I hate this)
  new Roles();
}());

