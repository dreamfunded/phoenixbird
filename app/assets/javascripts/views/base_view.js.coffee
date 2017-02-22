class App.Views.BaseView extends Backbone.View
  assign: (selector)->
    # https://ianstormtaylor.com/assigning-backbone-subviews-made-even-cleaner
    selectors = {}
    if _.isObject(selector)
      selectors = selector
    else
      selectors[selector] = view

    return if !selectors
    _.each(selectors, (view, selector) ->
      view.setElement(this.$(selector)).render()
    , this)