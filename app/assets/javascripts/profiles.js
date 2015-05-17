(function(){

  var Profile = function(){
    if ($('#controller-profiles').length > 0) {
      this.init();
    }
  };

  Profile.prototype.init = function() {
    $("#profiles_search input").keyup(function() {
      $.get($("#profiles_search").attr("action"), $("#products_search").serialize(), null, "script");
      return false;
    });
  };


  var MergeProfile = function() {
    if ($('#controller-profiles.action-merge').length > 0) {
      this.init();
    }
  };

  MergeProfile.prototype.init = function() {
    this.bindMergeProfileSelector();
    this.bindRunMergeBtn();
  };

  /**
    * Bind the profile Selector to update the player details on change
    */
  MergeProfile.prototype.bindMergeProfileSelector = function() {
    var self = this;
    $('#merge_profile_id').on('change', function(e) {
      var $this = $(this)
          new_profile_id = $this.val();
      self.getProfileDetails(new_profile_id);
    });
  };

  /**
    * Run Ajax to get the profile details of the given profile
    */
  MergeProfile.prototype.getProfileDetails = function(profileId) {
    $.ajax({
      url: '/profile_details',
      dataType:'JSON',
      data: {profile_id: profileId},
      success: function(data){
        if (data && data.html) {
          $('.js-merge-profile-details').html(data.html);
        }
      }
    });
  };

  /**
   *  Binds the event listener for running the merge
   */
  MergeProfile.prototype.bindRunMergeBtn = function() {
    var self = this;

    $('.js-run-merge').on('click', function(e){
      e.preventDefault();
      var $profile1 = $('.js-profile-1'),
          $profile1Details = $profile1.find('.js-profile-details'),
          profile1_id = $profile1Details.data('id'),
          profile1_name = $profile1Details.data('name'),
          $profile2 = $('.js-profile-2'),
          $profile2Details = $profile2.find('.js-profile-details'),
          profile2_id = $profile2Details.data('id'),
          profile2_name = $profile2Details.data('name');

      if (!profile1_id || !profile2_id) {
        self.showMergeError('Need two Profiles to run merge');
        return;
      }

      if (profile1_id == profile2_id) {
        self.showMergeError('Cannot merge two of the same profiles');
        return;
      }

      var isConfirmed = confirm('Are you sure you want to delete and merge ' + profile1_name + ' into ' + profile2_name + '. This will result in the deletion of ' + profile1_name + '(' + profile1_id  + ') and all rosters, committees, and board memberships will be merged into ' + profile2_name + '.');

      if (isConfirmed) {
        // run ajax to run the merge
        var postRequest = {
          'profile1_id' : profile1_id,
          'profile2_id' : profile2_id
        }; 

        $.ajax({
          url: 'merge',
          type: 'POST',
          dataType:'JSON',
          data: postRequest,
          success: function(data){
            if (data && data.success) {
              // show a message to indicate the profile was deleted
              $.toaster({ priority : 'success', title : 'Success!', message : data.success})
              // update the UI to see the removed psot
              if (data.profile_link) {
                window.location.replace(data.profile_link);
              }
            } else {
              self.showMergeError(data.error);
            }
          }
        });
      }
    });
  };

  MergeProfile.prototype.showMergeError = function(msg) {
    if (!msg) {
      msg = 'Something Went wrong please refresh and try again';
    }
    $.toaster({ priority : 'danger', title : 'Error!', message : msg});
  };

  var profile = new Profile();
  var mergeProfile = new MergeProfile();
}());
