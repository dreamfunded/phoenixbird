class App.Views.ProfileView extends App.Views.BaseView
  template: JST['users/profile']

  after_initialize: ->
    @about_section_view = new App.Views.UserEditableSection(
      title: "About"
      show_view: new App.Views.UserAboutSection
      edit_view: new App.Views.UserAboutEditSection
        )
    @investment_section_view = new App.Views.UserInvestmentSection(model: @model)

  render: ->
    @$el.html(@template(model: @model))

    @assign(
      '#about-section': @about_section_view
      '#investment-section': @investment_section_view
      )
    return this