require 'rails_helper'

feature 'create new campaign' do
    let!(:user) { FactoryGirl.create :user }
    before(:each) do
        visit root_path
        click_on "Login"
        fill_in "Email", :with => user.email
        fill_in "Password", :with => user.password
        click_button "Login"
    end

    scenario 'Basic step' do
        visit campaign_basics_path
        expect(page).to have_content('Campaign Basics')
    end
end
