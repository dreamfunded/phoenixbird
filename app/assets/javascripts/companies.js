$(document).on('ready', function(){

  $('.close-disclaimer').click(function(){
      $(this).parent().hide();
  })
});

$('.companies.index, .companies.show').ready(function() {
  $('.follow').followBtn();

  var $fixed_nav = $('#company-nav');
  var scroll_state = { away: false };
  var $window = $(window);

  $window.scroll(function() {
    if ($window.scrollTop() < 30) {
      if (scroll_state.away) {
        $fixed_nav.animate({top: '-' + $fixed_nav.height() + 'px'});
        scroll_state.away = false
      }
    } else if (!scroll_state.away) {
      $fixed_nav.animate({top: '0'});
      scroll_state.away = true
    }
  });
  $window.trigger('scroll');
})

$('.companies.show').ready(function() {
  var tag = document.createElement('script');

  tag.src = "https://www.youtube.com/iframe_api";
  var firstScriptTag = document.getElementsByTagName('script')[0];
  firstScriptTag.parentNode.insertBefore(tag, firstScriptTag);
})

function onYouTubeIframeAPIReady() {
  $('#video-play-button').videoPopup();
}