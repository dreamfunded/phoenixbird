class App.Views.ProfileView extends Backbone.View
  template: JST['users/profile']

  render: ->
    @$el.html(@template(model: @model))
    return this