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