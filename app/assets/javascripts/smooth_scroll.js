$.fn.smooth_scroll = function(options, callback) {
  var options  = $.extend({offset: 100, duration: 400}, options),
      duration = options['duration'],
      offset   = options['offset'];
  this.click(function() {
    if (this.pathname == undefined || (location.pathname.replace(/^\//,'') == this.pathname.replace(/^\//,'') &&
                                       location.hostname == this.hostname)) {
      var data_href = $(this).data('href');
      var hash = (data_href && data_href.match(/\#.*$/)[0]) || this.hash;
      var $target = $(hash);
      if ($target.length) {
        $('html, body').animate({
          scrollTop: $target.offset().top + offset
        }, duration, callback);
        return false;
      }
    }
  });
}