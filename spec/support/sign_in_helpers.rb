module SignInHelpers
    def sign_in
        visit root_path
        click_on "Login"
        fill_in "Email", :with => user.email
        fill_in "Password", :with => user.password
        click_button "Login"
    end
end

RSpec.configure do |config|
    config.include SignInHelpers
end
