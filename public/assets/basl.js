/*! simpleWeather v3.0.2 - http://simpleweatherjs.com */
!function(e){"use strict";function t(e,t){return Math.round("f"===e?5/9*(t-32):1.8*t+32)}e.extend({simpleWeather:function(i){i=e.extend({location:"",woeid:"",unit:"f",success:function(){},error:function(){}},i);var o=new Date,n="https://query.yahooapis.com/v1/public/yql?format=json&rnd="+o.getFullYear()+o.getMonth()+o.getDay()+o.getHours()+"&diagnostics=true&callback=?&q=";if(""!==i.location)n+='select * from weather.forecast where woeid in (select woeid from geo.placefinder where text="'+i.location+'" and gflags="R" limit 1) and u="'+i.unit+'"';else{if(""===i.woeid)return i.error({message:"Could not retrieve weather due to an invalid location."}),!1;n+="select * from weather.forecast where woeid="+i.woeid+' and u="'+i.unit+'"'}return e.getJSON(encodeURI(n),function(e){if(null!==e&&null!==e.query&&null!==e.query.results&&"Yahoo! Weather Error"!==e.query.results.channel.description){var o,n=e.query.results.channel,r={},s=["N","NNE","NE","ENE","E","ESE","SE","SSE","S","SSW","SW","WSW","W","WNW","NW","NNW","N"],a="https://s.yimg.com/os/mit/media/m/weather/images/icons/l/44d-100567.png";r.title=n.item.title,r.temp=n.item.condition.temp,r.code=n.item.condition.code,r.todayCode=n.item.forecast[0].code,r.currently=n.item.condition.text,r.high=n.item.forecast[0].high,r.low=n.item.forecast[0].low,r.text=n.item.forecast[0].text,r.humidity=n.atmosphere.humidity,r.pressure=n.atmosphere.pressure,r.rising=n.atmosphere.rising,r.visibility=n.atmosphere.visibility,r.sunrise=n.astronomy.sunrise,r.sunset=n.astronomy.sunset,r.description=n.item.description,r.city=n.location.city,r.country=n.location.country,r.region=n.location.region,r.updated=n.item.pubDate,r.link=n.item.link,r.units={temp:n.units.temperature,distance:n.units.distance,pressure:n.units.pressure,speed:n.units.speed},r.wind={chill:n.wind.chill,direction:s[Math.round(n.wind.direction/22.5)],speed:n.wind.speed},r.heatindex=n.item.condition.temp<80&&n.atmosphere.humidity<40?-42.379+2.04901523*n.item.condition.temp+10.14333127*n.atmosphere.humidity-.22475541*n.item.condition.temp*n.atmosphere.humidity-6.83783*Math.pow(10,-3)*Math.pow(n.item.condition.temp,2)-5.481717*Math.pow(10,-2)*Math.pow(n.atmosphere.humidity,2)+1.22874*Math.pow(10,-3)*Math.pow(n.item.condition.temp,2)*n.atmosphere.humidity+8.5282*Math.pow(10,-4)*n.item.condition.temp*Math.pow(n.atmosphere.humidity,2)-1.99*Math.pow(10,-6)*Math.pow(n.item.condition.temp,2)*Math.pow(n.atmosphere.humidity,2):n.item.condition.temp,"3200"==n.item.condition.code?(r.thumbnail=a,r.image=a):(r.thumbnail="https://s.yimg.com/zz/combo?a/i/us/nws/weather/gr/"+n.item.condition.code+"ds.png",r.image="https://s.yimg.com/zz/combo?a/i/us/nws/weather/gr/"+n.item.condition.code+"d.png"),r.alt={temp:t(i.unit,n.item.condition.temp),high:t(i.unit,n.item.forecast[0].high),low:t(i.unit,n.item.forecast[0].low)},r.alt.unit="f"===i.unit?"c":"f",r.forecast=[];for(var m=0;m<n.item.forecast.length;m++)o=n.item.forecast[m],o.alt={high:t(i.unit,n.item.forecast[m].high),low:t(i.unit,n.item.forecast[m].low)},"3200"==n.item.forecast[m].code?(o.thumbnail=a,o.image=a):(o.thumbnail="https://s.yimg.com/zz/combo?a/i/us/nws/weather/gr/"+n.item.forecast[m].code+"ds.png",o.image="https://s.yimg.com/zz/combo?a/i/us/nws/weather/gr/"+n.item.forecast[m].code+"d.png"),r.forecast.push(o);i.success(r)}else i.error({message:"There was an error retrieving the latest weather information. Please try again.",error:e.query.results.channel.item.title})}),this}})}(jQuery);

(function(){
  var local = 'https://basl-manager.herokuapp.com/loadsidebar';
  //'https://ratings-manager.herokuapp.com/loadsidebar'
  var Sidebar = function(){
    this.teamsnapSidebar = '.container .sponsors';
    this.initSponsors();
    this.initWeatherWidget();
  };

  Sidebar.prototype.initSponsors = function(){
    this.loadSidebarHtml();
  };

  Sidebar.prototype.loadSidebarHtml = function() {
    var self = this;
    $.ajax({
      url: local,
      success: function(html) {
        if (html) {
          $(self.teamsnapSidebar).html(html);
          self.initWeatherWidget(self.teamsnapSidebar);
        }
      },
      failed: function(data){
      },
      complete: function(data){
        
      }
    })
  };

  Sidebar.prototype.initWeatherWidget = function(container) {
    this.$container = $(container);
    this.$container.prepend('<div id="weather"></div>');
    this.$container.find('#weather').hide();
    this.loadWeatherWidget();
  };

  Sidebar.prototype.loadWeatherWidget = function() {
    if ($.simpleWeather) {
      $.simpleWeather({
        woeid: '2357536', //2357536
        location: '10010',
        unit: 'f',
        success: function(weather) {
          html = '<h3>Current Weather</h3>';
          html += '<h2> <i class="weather-icon"><img src="'+weather.thumbnail+'"></i>'+weather.temp+'&deg;'+weather.units.temp+'</h2>';
          html += '<ul><li>'+weather.city+', '+weather.region+'</li>';
          html += '<li class="currently">'+weather.currently+'</li>';
          html += '</ul>';

          /*for(var i=0;i<weather.forecast.length;i++) {
            html += '<p>'+weather.forecast[i].day+': '+weather.forecast[i].high+'</p>';
          }*/
          $('#weather').html(html).fadeIn();
        },
        error: function(error) {
          $("#weather").html('<p>'+error+'</p>');
        }
      });
    }
  };

  var sidebar = new Sidebar();

}());