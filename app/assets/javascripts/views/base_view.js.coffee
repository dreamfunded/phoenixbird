class App.Views.BaseView extends Backbone.View
  template: ->
  model: Backbone.Models

  initialize: ->
    @listenTo(@model, 'sync', @render) if @model?
    @after_initialize.apply(this, arguments)

  after_initialize: ->

  assign: (selector)->
    # https://ianstormtaylor.com/assigning-backbone-subviews-made-even-cleaner
    selectors = {}
    if _.isObject(selector)
      selectors = selector
    else
      selectors[selector] = view

    return if !selectors
    _.each(selectors, (view, selector) ->
      view.setElement(@$(selector)).render()
    , this)

  render: ->
    @$el.html(@template(model: @model))
    @after_render.apply(this, arguments)
    this

  after_render: ->