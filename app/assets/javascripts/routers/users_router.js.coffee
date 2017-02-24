class App.Routers.Users extends Backbone.Router
  routes:
    'users/profile': 'profile'

  profile: (id) ->
    user_id = id || App.current_user.get('id')
    user = new App.Models.User(id: user_id)
    view = new App.Views.ProfileView(model: user)
    user.fetch()
    $('#main-container').html(view.render().$el)