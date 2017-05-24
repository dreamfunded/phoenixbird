require 'rails_helper'

feature 'sign in as a user' do
    scenario 'with an email address' do
        visit root_path
        click_on "Sign Up"
        fill_in 'user_email', with: 'person@email.com'
        fill_in 'user_first_name', with: 'Alexandr'
        fill_in 'user_last_name', with: 'Smith'
        fill_in 'user_password', with: 'password'
        fill_in 'user_password_confirmation', with: 'password'
        check('box1')
        check('box4')
        click_button 'Sign Up'
        expect(page).to have_content('Alexandr')
    end

end
