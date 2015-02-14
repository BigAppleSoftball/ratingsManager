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

  var profile = new Profile();
}());
