$(document).on('ready', function(){

  $('.close-disclaimer').click(function(){
      $(this).parent().hide();
  })
});

$('.companies.index, .companies.show').ready(function() {
  $('.follow').followBtn();
  $('a[href*="#"]:not([href="#"])').smooth_scroll({offset: -30});

  var $fixed_nav = $('#company-nav');
  var $window = $(window);

  $window.scroll_away({
    offset: 30,
    away: function() {
      $fixed_nav.animate({top: '0'});
    },
    back: function() {
      $fixed_nav.animate({top: '-' + $fixed_nav.height() + 'px'});
    }
  })
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