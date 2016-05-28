module ApplicationHelper

  def sign_in
    visit('/')
    click_link('Sign up')
    fill_in('Email', with: 'sity@pop.com')
    fill_in('Password', with: 'secret')
    fill_in('Password confirmation', with: 'secret')
    click_button('Sign up')
  end

end
