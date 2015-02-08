(function(){

  var Carousel = function(){
    this.init();
  };

  /**
   * Intializes the plugin
   */
  Carousel.prototype.init = function() {
    this.$container = $('.js-sponsors-carousel');
    if (this.$container.length > 0) {
      this.itemHeight = 200;
      this.currentPage = 0;
      this.pageCount = this.getNumberOfImages();
      this.initAutoPageChange();
    }
  };

  /**
    * Wraps the ul list of images with a container
    * used mainly for styling
    */
  Carousel.prototype.wrapContainer = function() {
    this.$container.wrap('<div class="cf ' + this.options.wrapperClass + '"></div>');
  };

  /**
   * Assumes the number of direct li's is the number of 'pages' in the carousel
   */
  Carousel.prototype.getNumberOfImages = function() {
    return this.$container.find('> li').length;
  };

  /**
   * Changes the page
   */
  Carousel.prototype.changePage = function() {
    // change the margin to bring the right img into the frame
    this.$container.css('margin-top', -(this.itemHeight * this.currentPage));;
    this.currentPage++;
    // if we get past the total number of pages go back to the first page
    if (this.currentPage >= this.pageCount) {
      this.currentPage = 0;
    }
  };

  /**
   * intializes the set time out to show the page change
   * calls itself ever 5000 ms
   */
  Carousel.prototype.initAutoPageChange = function() {
    var self = this;
    self.changePage();
      setTimeout(function() {
          self.initAutoPageChange();
      }, 3000);
  };

  var carousel = new Carousel();

}());