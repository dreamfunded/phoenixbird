$(document).on('ready', function(){

  $('.close-disclaimer').click(function(){
      $(this).parent().hide();
  })
});

$('.companies.show').ready(function() {
  var tag = document.createElement('script');

  tag.src = "https://www.youtube.com/iframe_api";
  var firstScriptTag = document.getElementsByTagName('script')[0];
  firstScriptTag.parentNode.insertBefore(tag, firstScriptTag);
})

function onYouTubeIframeAPIReady() {
  $('#video-play-button').videoPopup();
}