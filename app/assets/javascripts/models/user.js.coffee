class App.Models.User extends Backbone.Model
  urlRoot: '/api/users'

  investments: ->
    new App.Collections.Investments(@get('investments'))

  websites: ->
    website_links = _.map(@get('websites'), (link)-> {text: link})
    new App.Collections.BaseCollection(website_links)