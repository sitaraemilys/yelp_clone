require 'rails_helper'

feature 'Reviewing' do

before { Restaurant.create(name: 'KFC') }

	context 'User is signed in' do

		before do
			visit('/')
			click_link('Sign up')
			fill_in('Email', with: 'sity@pop.com')
			fill_in('Password', with: 'secret')
			fill_in('Password confirmation', with: 'secret')
			click_button('Sign up')

		end

		it 'allows users to leave a review using a form' do
			visit '/'
			click_link 'Review KFC'
			fill_in 'Thoughts', with: 'so so'
			select '3', from: 'Rating'
			click_button 'Leave Review'

			expect(page).to have_content("so so")
			expect(current_path).to eq("/restaurants")
		end
	end

	context 'User is not signed in' do
		it 'should not be able to make a review' do
			visit('/')
			expect(page).not_to have_link 'Review KFC'
		end
	end

end
