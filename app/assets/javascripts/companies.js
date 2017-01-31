$(document).on('ready', function(){

  $('.close-disclaimer').click(function(){
      $(this).parent().hide();
  })

  $('#video-play-button').videoPopup();
});
