(function(){

  var Sidebar = function(){
    this.init();
  };

  Sidebar.prototype.init = function(){
    console.log('ingint sidebar');
    this.loadSidebarHtml();
  };

  Sidebar.prototype.loadSidebarHtml = function() {

  };

  var sidebar = new Sidebar();

}());