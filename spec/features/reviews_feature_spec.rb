require 'rails_helper'

feature 'reviewing' do
	before { Restaurant.create(name: 'KFC') }

	scenario 'allows users to leave a review using a form' do
		visit '/restaurants'
		click_link 'Review KFC'
		fill_in 'Thoughts', with: 'so so'
		select '3', from: 'Rating'
		click_button 'Leave Review'

		expect(page).to have_content("so so")
		expect(current_path).to eq("/restaurants")
	end

	context 'user is not signed in' do
		it 'should not see review restaurant' do
			visit('/')
			expect(page).not_to have_link 'Review KFC'
		end
	end
end
