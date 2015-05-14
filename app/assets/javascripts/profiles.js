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
        console.log(data);
        if (data && data.html) {
          $('.js-merge-profile-details').html(data.html);
        }
      }
    });
  };

  var profile = new Profile();
  var mergeProfile = new MergeProfile();
}());
