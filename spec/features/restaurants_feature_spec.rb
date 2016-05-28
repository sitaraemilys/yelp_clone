require 'rails_helper'

feature 'Restaurants' do

	context 'User is signed in' do

		before do
			visit('/')
			click_link('Sign up')
			fill_in('Email', with: 'sity@pop.com')
			fill_in('Password', with: 'secret')
			fill_in('Password confirmation', with: 'secret')
			click_button('Sign up')
		end

		describe 'no restaurants have been added' do
			it 'should display a prompt to add a restaurant' do
				visit '/'
				expect(page).to have_content("No restaurants yet")
				expect(page).to have_link("Add a restaurant")
			end
		end

		describe 'restaurants have been added' do
			let!(:kfc) { Restaurant.create(name: 'KFC') }
			it 'displays restaurants' do
				visit '/'
				expect(page).to have_content("KFC")
				expect(page).not_to have_content("No restaurants yet")
				expect(page).to have_link("Add a restaurant")
			end

			it 'lets user view restaurants' do
				visit '/'
				click_link 'KFC'
				expect(page).to have_content("KFC")
				expect(current_path).to eq("/restaurants/#{kfc.id}")
			end
		end

		describe 'creating restaurants' do
			it 'prompts user with form, then displays new restaurant' do
				visit '/'
				click_link 'Add a restaurant'
				fill_in 'Name', with: 'KFC'
				click_button 'Create Restaurant'
				expect(page).to have_content("KFC")
			end

			it 'does not let user submit a name that is too short' do
				visit '/'
				click_link 'Add a restaurant'
				fill_in 'Name', with: 'kf'
				click_button 'Create Restaurant'

				expect(page).not_to have_css 'h2', text: 'kf'
				expect(page).to have_content 'error'
			end
		end

		describe 'ability to edit and delete a restaurant user created' do

			before do
				click_link('Add a restaurant')
				fill_in 'Name', with: 'Silk Road'
				click_button 'Create Restaurant'
			end

			it 'lets user edit that restaurant' do
				visit '/'
				click_link 'Edit Silk Road'
				fill_in 'Name', with: 'Silk Road'
				fill_in 'Description', with: 'Cheeky chinese'
				click_button 'Update Restaurant'
				expect(page).to have_content("Silk Road")
				expect(page).to have_content("Cheeky chinese")
				expect(current_path).to eq("/restaurants")
			end

			it 'lets user delete that restaurant' do
				visit '/'
				click_link 'Delete Silk Road'
				expect(page).not_to have_content("Silk Road")
				expect(page).to have_content("Restaurant deleted successfully")
			end
		end
	end


		context 'User is not siged in' do

			let!(:kfc) { Restaurant.create(name: 'KFC') }

			describe 'restaurants have been added' do
				it 'displays restaurants' do
					visit '/'
					expect(page).to have_content 'KFC'
					expect(page).not_to have_content("No restaurants yet")
					expect(page).to have_link("Add a restaurant")
				end
				it 'lets user view restaurants' do
					visit '/'
					click_link 'KFC'
					expect(page).to have_content("KFC")
					expect(current_path).to eq("/restaurants/#{kfc.id}")
				end
			end

			describe 'adding restaurants' do
				it 'should not able to add a restaurant' do
					visit '/'
					click_link 'Add a restaurant'
					expect(page).to have_content 'Sign up'
				end
			end

			describe 'editing restaurants' do
				it 'should not able to edit a restaurant that user has not added themselves' do
					visit '/'
					expect(page).not_to have_link 'Edit KFC'
				end
			end

			describe 'deleting restaurants' do
				it 'should not be able to delete a restaurant that user has not added themselves' do
					visit '/'
					expect(page).not_to have_link 'Delete KFC'
				end
			end
		end

end
