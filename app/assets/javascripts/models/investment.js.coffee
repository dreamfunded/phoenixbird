class App.Models.Investment extends Backbone.Model
  company: ->
    new App.Models.Company(@get('company'))