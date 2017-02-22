class App.Views.ProfileView extends App.Views.BaseView
  template: JST['users/profile']

  initialize: ->
    @about_section_view = new App.Views.UserAboutSection

  render: ->
    @$el.html(@template(model: @model))

    @assign(
      '#about-section': @about_section_view
      )
    return this