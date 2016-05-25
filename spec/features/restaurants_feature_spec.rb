require 'rails_helper'

feature 'Restaurants' do

	context 'no restaurants have been added' do
		scenario 'should display a prompt to add a restaurant' do
			visit '/restaurants'
			expect(page).to have_content("No restaurants yet")
			expect(page).to have_link("Add a restaurant")
		end
	end

	context 'restaurants have been added' do

		before do
			Restaurant.create(name: 'KFC')
		end

		scenario 'display restaurants' do
			visit '/restaurants'
			expect(page).to have_content("KFC")
			expect(page).not_to have_content("No restaurants yet")
			expect(page).to have_link("Add a restaurant")
		end
	end

	context 'creating restaurants' do

		before do
			visit('/')
			click_link('Sign up')
			fill_in('Email', with: 'sity@pop.com')
			fill_in('Password', with: 'secret')
			fill_in('Password confirmation', with: 'secret')
			click_button('Sign up')
		end

		it 'prompts user with form, then displays new restaurant' do
			visit '/restaurants'
			click_link 'Add a restaurant'
			fill_in 'Name', with: 'KFC'
			click_button 'Create Restaurant'
			expect(page).to have_content("KFC")
		end

		context 'an invalid restaurant' do
			it 'does not let you submit a name that is too short' do
				visit '/restaurants'
				click_link 'Add a restaurant'
				fill_in 'Name', with: 'kf'
				click_button 'Create Restaurant'

				expect(page).not_to have_css 'h2', text: 'kf'
				expect(page).to have_content 'error'
			end
		end

	end

	context 'viewing restaurants' do

		let!(:kfc) { Restaurant.create(name: 'KFC') }

		scenario 'lets user view restaurants' do
			visit '/restaurants'
			click_link 'KFC'
			expect(page).to have_content("KFC")
			expect(current_path).to eq("/restaurants/#{kfc.id}")
		end
	end

	context 'editing restaurants' do

		before { Restaurant.create(name: 'KFC', description: 'Shallow fried goodness') }

		context 'user is signed in' do

			before do
				visit('/')
				click_link('Sign up')
				fill_in('Email', with: 'sity@pop.com')
				fill_in('Password', with: 'secret')
				fill_in('Password confirmation', with: 'secret')
				click_button('Sign up')
			end

			it 'lets user edit a restaurant' do
				visit '/restaurants'
				click_link 'Edit KFC'
				fill_in 'Name', with: 'KFC'
				fill_in 'Description', with: 'Deep fried goodness'
				click_button 'Update Restaurant'
				expect(page).to have_content("KFC")
				expect(page).to have_content("Deep fried goodness")
				expect(current_path).to eq("/restaurants")
			end
		end

		context 'user is not signed in' do
			it 'should not able to edit a restaurant' do
				visit '/restaurants'
				click_link 'Edit KFC'
				expect(page).to have_link 'Sign in'
			end
		end
	end

	context 'deleting restaurants' do

		before { Restaurant.create(name: 'KFC', description: 'Shallow fried goodness') }

		context 'user is signed in' do
			before do
				visit('/')
				click_link('Sign up')
				fill_in('Email', with: 'sity@pop.com')
				fill_in('Password', with: 'secret')
				fill_in('Password confirmation', with: 'secret')
				click_button('Sign up')
			end

			it 'lets user delete a restaurant' do
				visit '/restaurants'
				click_link 'Delete KFC'
				expect(page).not_to have_content("KFC")
				expect(page).to have_content("Restaurant deleted successfully")
			end
		end

		context 'user is not signed in' do
			it 'should not be able to delete a restaurant' do
				visit('/')
				click_link 'Delete KFC'
				expect(page).to have_link 'Sign in'
			end
		end
	end

end
