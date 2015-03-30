require 'rails_helper'

feature 'reviewing' do
  before {Restaurant.create name: 'KFC'}

  def add_review
    visit '/restaurants'
     click_link 'Review KFC'
     fill_in "Thoughts", with: "so so"
     select '3', from: 'Rating'
     click_button 'Leave Review'
     expect(current_path).to eq '/restaurants'
     expect(page).to have_content('so so')
  end

  scenario 'allows users to leave a review using a form' do
     add_review
  end

  scenario 'deletes a review when a restaurant is deleted' do
    add_review
    click_link "Delete KFC"
    expect(page).not_to have_content 'KFC'
    expect(page).to have_content 'Restaurant deleted successfully'
  end

end
