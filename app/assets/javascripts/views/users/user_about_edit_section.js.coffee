class App.Views.UserAboutEditSection extends App.Views.BaseView
  template: JST['users/about_edit_section']

  after_render: ->
    @setup()

  setup: ->
    @$('.js-select2-tags').select2(
      tags: true
      tokenSeparators: [',']
      width: '100%'
      )