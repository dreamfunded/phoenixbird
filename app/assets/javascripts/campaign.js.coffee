# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$('.campaigns.edit_campaign').ready(->
  $('#testimonials').on('cocoon:after-insert', (e) ->
    if $('.nested-fields', this).length >= $(this).data('limit')
      $('.links', this).hide()
    ).trigger('cocoon:after-insert')
)