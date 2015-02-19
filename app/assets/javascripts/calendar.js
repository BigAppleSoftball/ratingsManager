(function(){

  var Calendar = function(){
    this.$calendar = $('.js-calendar');
    if (this.$calendar.length > 0) {
      this.init();
    }
  };

  Calendar.prototype.init = function() {
    var self = this;

    $.ajax({
      url: 'https://www.googleapis.com/calendar/v3/calendars/mmj1jt517n3pisesj1ehs74vnk@group.calendar.google.com/events?key=AIzaSyCoGxbgo50sQ98aSQxXUwyeZexTwkWYUlI&timeMin=2015-02-19T00:00:00-05:00',
      dataType: 'jsonp',
      success: function(data) {
        console.log(data);
        var events = data.items,
            eventsContainer = $('<ul />', {'class' : 'calendar-event-list'});
        $.each(events, function(){
          var eventContainer = $('<li />', { 'class' : 'calendar-event-item'});
           eventContainer.append($('<div />', { 'text' : this.summary}));
          eventContainer.append($('<div />', { 'text' : this.location}));
          eventContainer.append($('<div />', { 'text' : this.description}));
          eventContainer.append($('<div />', { 'text' : this.start.dateTime}));
          eventContainer.append($('<div />', { 'text' : this.end.dateTime}));
          eventsContainer.append(eventContainer);
        });
        self.$calendar.html(eventsContainer);
      },
      failed: function(data){
      },
      complete: function(data){
        
      }
    })
  };
  var calendar = new Calendar();
  
}());