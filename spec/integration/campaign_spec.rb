require 'rails_helper'

feature 'create new campaign' do
    let!(:user) { FactoryGirl.create :user }
    before(:each) do
      stub_current_user user
    end

    scenario 'Basic step' do
        visit campaign_basics_path
        expect(page).to have_content('Campaign Basics')
    end
end
