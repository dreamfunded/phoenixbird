require 'rails_helper'
require 'spec_helper'

feature 'User Sign Up' do
    scenario 'with first, last email and passwords and checkboxes clicked' do
        visit root_path
        click_on "Sign Up"
        fill_in 'user_email', with: 'person1@email.com'
        fill_in 'user_first_name', with: 'Alexandr'
        fill_in 'user_last_name', with: 'Smith'
        fill_in 'user_password', with: 'password'
        fill_in 'user_password_confirmation', with: 'password'
        check('box1')
        check('box3')
        check('box4')
        click_button 'Sign Up'
        expect(page).to have_content('Alexandr')
        expect { click_on("Sign Up") }.to raise_error(Capybara::ElementNotFound)
    end

    scenario 'without first and last name' do
        visit root_path
        click_on "Sign Up"
        fill_in 'user_email', with: 'person@email.com'
        fill_in 'user_password', with: 'password'
        fill_in 'user_password_confirmation', with: 'password'
        check('box1')
        check('box3')
        check('box4')
        click_button 'Sign Up'
        expect(page).to have_content('prohibited this user from being saved:')
    end
end


feature 'Authentication' do
    let!(:user) { FactoryGirl.create :user }
    scenario "redirects to root_path on success and replaces login with user name" do

            visit root_path
            click_on "Login"
            fill_in "Email", :with => user.email
            fill_in "Password", :with => user.password
            click_button "Login"
            expect(page).to have_content(user.first_name)
            expect { click_on("Log In") }.to raise_error(Capybara::ElementNotFound)

    end
end
