class App.Models.User extends Backbone.Model
  urlRoot: '/api/users'

  investments: ->
    new App.Collections.Investments(@get('investments'))