require 'spec_helper'
require 'rails_helper'

feature 'visit Homepage' do
    scenario 'user sees right content' do
        visit root_path
        expect(page).to have_css '.mainTop__slider .mainTop__slider__title h2', text: 'Invest in Local Business'
        expect(page).to have_css '.mainTop__slider .mainTop__slider__txt span', text: 'And Get a Share of Their Profits'
    end
end


