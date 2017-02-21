class App.Routers.Users extends Backbone.Router
  routes:
    'users/profile': 'profile'

  profile: ->
    view = new App.Views.ProfileView(model: App.current_user)
    $('#main-container').html(view.render().$el)