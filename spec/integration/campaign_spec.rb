require 'rails_helper'

feature 'create new campaign'  do
    let(:user) { FactoryGirl.create :user }
    let(:company_attr) { FactoryGirl.attributes_for :company }
    let(:campaign_attr) { FactoryGirl.attributes_for :campaign }



    # scenario 'Basic step' do
    #     sign_in
    #     visit campaign_basics_path
    #     expect(page).to have_content('Campaign Basics')
    # end

    scenario 'Submit Campaign' do
        sign_in
        visit campaign_basics_path
        fill_in 'company_name', with: company_attr[:name]
        fill_in 'tagline', with: campaign_attr[:tagline]
        select('Art', :from => 'company_category')
        fill_in 'company_description', with: company_attr[:description]
        click_on 'Continue'
        expect(page).to have_content('Campaign Details')


        fill_in 'video_link', with: 'youtube url'
        fill_in 'campaign_elevator_pitch', with: campaign_attr[:elevator_pitch]
        fill_in 'campaign_about_campaign', with: campaign_attr[:about_campaign]
        fill_in 'campaign_employees_numer', with: campaign_attr[:employees_numer]
        click_on 'Continue'
        expect(page).to have_content('Legal Info')

        fill_in 'campaign_legal_company_name', with: 'Legal Name'
        fill_in 'campaign_state_where_incorporated', with: campaign_attr[:state_where_incorporated]

        fill_in "campaign_company_location_address", with: campaign_attr[:company_location_address]
        fill_in "campaign_company_location_city", with: campaign_attr[:company_location_city]
        fill_in "campaign_company_location_state", with: campaign_attr[:company_location_state]
        fill_in "campaign_company_location_zipcode", with: campaign_attr[:company_location_zipcode]
        click_on "Complete"
        expect(page).to have_content('Invite Friends')

        click_on "Complete"
        expect(page).to have_content( company_attr[:name] )
        expect(page).to have_content( campaign_attr[:tagline] )
        expect(page).to have_content( campaign_attr[:company_location_city] + ', ' +  campaign_attr[:company_location_state])
        expect(page).to have_content(company_attr[:description])
        expect(page).to have_content( campaign_attr[:elevator_pitch] )
        expect(page).to have_content( campaign_attr[:about_campaign] )
    end
end
