require 'rails_helper'

def sign_up
  visit('/')
  click_link('Sign up')
  fill_in('Email', with: 'test@example.com')
  fill_in('Password', with: 'testtest')
  fill_in('Password confirmation', with: 'testtest')
  click_button('Sign up')
end

def user_create_restaurant_KFC
  visit '/restaurants'
  click_link 'Add a restaurant'
  fill_in 'Name', with: 'KFC'
  click_button 'Create Restaurant'
end


feature 'restaurants' do

  context 'no restaurants have been added' do
    scenario 'should display a prompt to add a restaurant' do
      visit '/restaurants'
      expect(page).to have_content 'No restaurants yet'
      expect(page).to have_link 'Add a restaurant'
    end
  end

  context 'restaurants have been added' do

    before do
      Restaurant.create(name: 'KFC')
    end

    scenario 'display restaurants' do
      visit '/restaurants'
      expect(page).to have_content('KFC')
      expect(page).not_to have_content('No restaurants yet')
    end

  end

  context 'creating restaurants' do
    scenario 'prompts user to fill out a form, then displays the new restaurant' do
      sign_up
      user_create_restaurant_KFC
      expect(page).to have_content 'KFC'
      expect(current_path).to eq '/restaurants'
    end

    context 'an invalid restaurant' do
      it 'does not let you submit a name that is too short' do
        sign_up
        visit '/restaurants'
        click_link 'Add a restaurant'
        fill_in 'Name', with: 'Kf'
        click_button 'Create Restaurant'
        expect(page).not_to have_css 'h2', text: 'kf'
        expect(page).to have_content 'error'
      end
    end

  end

  context 'viewing restaurants' do

    let!(:kfc){Restaurant.create(name:'KFC')}

    scenario 'lets a user view a restaurant' do
      sign_up
      visit '/restaurants'
      click_link 'KFC'
      expect(page).to have_content 'KFC'
      expect(current_path).to eq "/restaurants/#{kfc.id}"
    end

  end

  context 'editing restaurants' do

    before{Restaurant.create name:'Burger King'}

    scenario 'does not let a user edit a restaurant that they did not create' do
      sign_up
      visit '/restaurants'
      user_create_restaurant_KFC
      click_link 'Edit Burger King'
      expect(current_path).to eq '/restaurants'
      expect(page).to have_content 'Can only edit restaurants you have created'
    end

    scenario 'lets a user edit a restaurant that they created' do
      sign_up
      visit '/restaurants'
      user_create_restaurant_KFC
      click_link 'Edit KFC'
      fill_in 'Name', with: 'Kentucky Fried Chicken'
      click_button 'Update Restaurant'
      expect(page).to have_content 'Kentucky Fried Chicken'
      expect(current_path).to eq '/restaurants'
    end

  end

  context 'deleting restaurants' do

    before {Restaurant.create name: 'KFC'}

    scenario 'removes a restaurant when a user clicks a delete link' do
      sign_up
      visit '/restaurants'
      click_link "Delete KFC"
      expect(page).not_to have_content 'KFC'
      expect(page).to have_content 'Restaurant deleted successfully'
    end

  end



end