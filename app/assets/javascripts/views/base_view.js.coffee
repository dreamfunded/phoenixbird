class App.Views.BaseView extends Backbone.View
  template: ->

  initialize: (options)->
    @listenTo(@model, 'sync', @render) if @model?
    @listenTo(@collection, 'add', @render) if @collection?
    @after_initialize.apply(this, arguments)

  after_initialize: ->

  assign: (selector)->
    # https://ianstormtaylor.com/assigning-backbone-subviews-made-even-cleaner
    selectors = {}
    if _.isObject(selector)
      selectors = selector
    else
      selectors[selector] = view

    _.each(selectors, (view, selector) ->
      view.setElement(@$(selector)).render()
    , this)

  render: ->
    @$el.html(@template(model: @model))
    @after_render.apply(this, arguments)
    this

  after_render: ->

  set_state: (new_state) ->
    _.extend(@state, new_state)
    @render()

  serialize: ($target)->
    $target = $target || @$el
    $.deparam($target.serialize())