# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$('.campaigns.edit_campaign').ready(->
  $('#testimonials').on('cocoon:after-insert', (e) ->
    if $('.nested-fields', this).length >= $(this).data('limit')
      $('.links', this).hide()
    ).trigger('cocoon:after-insert')

  $('a[href*="#"]:not([href="#"])').smooth_scroll({offset: -30})

  $fixed_nav = $('#company-nav')
  $window = $(window)

  $window.scroll_away({
    offset: 30
    away: ->
      $fixed_nav.animate({top: '0'})
    back: ->
      $fixed_nav.animate({top: '-' + $fixed_nav.height() + 'px'})
  })
)