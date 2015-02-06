// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.


$(document).ready(function(){
  var $sponsorsList = $('.js-sponsors-list');

  if ($sponsorsList.length > 0) {
    var sponsorsPage = new SponsorsPage($sponsorsList);
  }
});

var SponsorsPage = function($container) {
  this.$container = $container;
  this.init();
};

SponsorsPage.prototype.init = function(){
  var self = this;
  this.$container.isotope({
    itemSelector: '.js-sponsors-list-item',
    masonry: {
      columnWidth: 155,
      gutter: 5
    }
  });

  $('.js-sponsors-list-item').click(function(e) {
    var $this = $(this);
    if ($(e.target).closest('a').length) {
      return;
    }
    if ($this.hasClass('active-item')) {
      $this.find('.js-sponsors-list-item-more').hide();
      $this.removeClass('active-item');
    } else {
      var $otherActive = $('.js-sponsors-list-item.active-item');
      $otherActive.find('.js-sponsors-list-item-more').hide();
      $otherActive.removeClass('active-item');
      $this.addClass('active-item');
      $this.find('.js-sponsors-list-item-more').fadeIn();
    }
    self.$container.isotope('layout');
  });
};
