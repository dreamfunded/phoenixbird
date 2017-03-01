class App.Views.WebsiteLinkItem extends App.Views.BaseView
  tagName: "input"
  attributes:
    type: "text"
    name: "websites[]"
  className: "form-field"

  after_initialize: (options)->
    @text = options.text

  render: ->
    @$el.val(@text)
    return this