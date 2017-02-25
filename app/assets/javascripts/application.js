// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require jquery.readyselector
//= require ckeditor/init
//= require bootstrap.min
//= require select2
//= require instafilta.min
//= require turbolinks
//= require links
//= require cocoon
//= require slick.min
//= require companies
//= require tinyscrollbar.min
//= require jquery.tinyscrollbar.min
//= require jquery.countdown.min
//= require jquery-deparam.min
//= require underscore
//= require backbone
//= require_self
//= require_tree ../templates
//= require_tree ./models
//= require_tree ./collections
//= require_tree ./views
//= require_tree ./routers
//= require_tree .

window.App = {
  Models: {},
  Collections: {},
  Views: {},
  Routers: {},
  should_load: function() {
    let supported_pages = ['.users.profile'];
    let supported_pages_class = supported_pages.join(', ');
    return $(supported_pages_class).length > 0;
  },
  initialize: function() {
    new App.Routers.Users();
    Backbone.history.start({pushState: true});
  }
}

$(document).on('page:change', function() {
  if (App.should_load()) {
    App.initialize()
  }
})