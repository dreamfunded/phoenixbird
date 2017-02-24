class App.Views.UserEditableSection extends App.Views.BaseView
  template: JST['users/editable_section']

  events:
    "click .toggle-edit": "toggle_edit"

  after_initialize: (options)->
    @state = { is_editing: true }
    @show_view = options.show_view
    @edit_view = options.edit_view
    @title = options.title

  render: ->
    @$el.html(@template(title: @title))
    view = if @state.is_editing then @edit_view else @show_view
    @assign('.section-container': view)
    return this

  toggle_edit: (e)->
    e.preventDefault()
    @set_state(is_editing: !@state.is_editing)

  set_state: (new_state) ->
    _.extend(@state, new_state)
    @render()