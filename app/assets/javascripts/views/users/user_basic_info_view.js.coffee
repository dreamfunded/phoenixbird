class App.Views.UserBasicInfo extends App.Views.BaseView
  template: JST['users/basic_info_section']

  events:
    'click .edit-profile': 'edit_profile'
    'submit': 'form_submit'

  after_initialize: ->
    @state = { is_editing: true }

  render: ->
    @user_websites_view = new App.Views.CollectionView(collection: @model.websites())
    @user_websites_view.list_item_view = App.Views.WebsiteLinkItem
    @$el.html(@template(state: @state, model: @model))

    @assign(
      '#user_websites': @user_websites_view
      )
    return this

  edit_profile: (e)->
    e.preventDefault();
    @set_state(is_editing: !@state.is_editing)

  form_submit: (e)->
    $target = $(e.target)
    data = @serialize($target)
    @model.save(data)
    @edit_profile(e)