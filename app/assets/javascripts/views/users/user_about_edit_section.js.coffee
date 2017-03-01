class App.Views.UserAboutEditSection extends App.Views.BaseView
  template: JST['users/about_edit_section']

  events:
    'submit': 'form_submit'

  after_render: ->
    @setup()

  setup: ->
    @$('.js-select2-tags').select2(
      tags: true
      tokenSeparators: [',']
      width: '100%'
      )

  form_submit: (e)->
    e.preventDefault()
    $target = $(e.target)
    data = @serialize($target)
    @model.save(data)
    @on_submit(e)

  on_submit: (e) ->