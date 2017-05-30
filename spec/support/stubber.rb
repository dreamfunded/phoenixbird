module Stubber
  def stub_current_user user
    allow_any_instance_of(ApplicationController).to receive(:current_user) { user }
  end

  def login(user)
    visit root_path
    click_on "Login"
    fill_in "Email", :with => user.email
    fill_in "Password", :with => user.password
    click_button "Login"
  end
end
