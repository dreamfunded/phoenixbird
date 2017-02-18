$(document).on('ready', function(){

  $('.close-disclaimer').click(function(){
      $(this).parent().hide();
  })
});

$(document).on('page:change ready',function() {
  var $fixed_nav = $('#company-nav');
  var $window = $(window);
  var tag = document.createElement('script');

  tag.src = "https://www.youtube.com/iframe_api";
  var firstScriptTag = document.getElementsByTagName('script')[0];
  firstScriptTag.parentNode.insertBefore(tag, firstScriptTag);

  $('#testimonials').on('cocoon:after-insert', function(e) {
    if ($('.nested-fields', this).length >= $(this).data('limit')) {
      $('.links', this).hide();
    }
  }).trigger('cocoon:after-insert')

  $window.scroll_away({
    offset: 30,
    away: function() {
      $fixed_nav.animate({top: '0'});
    },
    back: function() {
      $fixed_nav.animate({top: '-' + $fixed_nav.height() + 'px'});
    }
  })

  $('.follow[data-company-id]').followBtn();
  $('a[href*="#"]:not([href="#"])').smooth_scroll({offset: -30});
})

function onYouTubeIframeAPIReady() {
  $('#video-play-button').videoPopup();
}