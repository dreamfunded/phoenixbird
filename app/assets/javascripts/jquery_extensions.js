$.fn.scroll_away = function(options) {
  var _this = this;
  var away_fn = options.away;
  var back_fn = options.back;
  var scroll_state = { away: false };
  var offset = options.offset;

  _this.scroll(function() {
    if (_this.scrollTop() < offset) {
      if (scroll_state.away) {
        back_fn.call(this);
        scroll_state.away = false
      }
    } else if (!scroll_state.away) {
      away_fn.call(this);
      scroll_state.away = true
    }
  });
  _this.trigger('scroll');
}

// https://www.sitepoint.com/oauth-popup-window/
// Authorization popup window code
$.oauthpopup = function(options) {
    options.windowName = options.windowName ||  'ConnectWithOAuth'; // should not include space for IE
    options.windowOptions = options.windowOptions || 'location=0,status=0,width=800,height=400';
    options.callback = options.callback || function(){ window.location.reload(); };
    var _this = this;

    _this._oauthWindow = window.open(options.path, options.windowName, options.windowOptions);
    _this._oauthInterval = window.setInterval(function(){
      if (_this._oauthWindow.closed) {
        window.clearInterval(_this._oauthInterval);
        options.callback();
      }
    }, 1000);
};

$.fn.oauthPhotoGetter = function(target, options) {
  var _this = this;
  var $target = $(target);
  var options = options || {}

  this.click(function(e) {
    e.preventDefault();

    $.oauthpopup({
      path: _this[0].href,
      callback: function() {
        window.location.reload();
      }
    })
  })
}

$.classNames = function(stateClasses) {
  var value;
  return Object.keys(stateClasses).reduce(function(acc, className) {
    value = stateClasses[className]
    if (value) { return acc + className + " " }
    return acc
  }, '').trim()
}
