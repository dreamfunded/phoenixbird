class App.Views.CollectionView extends App.Views.BaseView
  after_initialize: (options)->
    @list_item_view = options.list_item_view

  render: ->
    @collection.each(@add_one, this)
    return this

  add_one: (item)->
    list_item_view = new @list_item_view(item.toJSON())
    @$el.append(list_item_view.render().$el)