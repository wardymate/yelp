require 'rails_helper'

feature 'reviewing' do
  before {Restaurant.create name: 'Burger King'}

  def leave_review(thoughts, rating)
    visit '/restaurants'
    click_link 'Review Burger King'
    fill_in "Thoughts", with: thoughts
    select rating, from: 'Rating'
    click_button 'Leave Review'
  end

  def sign_up
    visit('/')
    click_link('Sign up')
    fill_in('Email', with: 'test@example.com')
    fill_in('Password', with: 'testtest')
    fill_in('Password confirmation', with: 'testtest')
    click_button('Sign up')
  end

  scenario 'allows users to leave a review using a form' do
    sign_up
    leave_review('so so', '3')
    expect(current_path).to eq '/restaurants'
    expect(page).to have_content('so so')
  end

  scenario 'displays an average rating for all reviews' do
    leave_review('So so', '3')
    leave_review('Great', '5')
    expect(page).to have_content('Average rating: ★★★★☆')
  end

  xscenario 'does not allow users to leave a review to a restaurant they have already reviewed' do
    sign_up
    leave_review
    leave_review
    expect(current_path).to eq '/restaurants'
    expect(page).to have_content 'Can only review a restaurant once!'
  end


  scenario 'deletes a review when a restaurant is deleted' do
    sign_up
    visit '/restaurants'
    click_link 'Add a restaurant'
    fill_in 'Name', with: 'KFC'
    click_button 'Create Restaurant'
    leave_review('so so', '3')
    click_link "Delete KFC"
    expect(page).not_to have_content 'KFC'
    expect(page).to have_content 'Restaurant deleted successfully'
  end

end
