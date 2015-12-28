require 'rails_helper'

feature "Define a new Line", type: :feature do
  scenario "I create a new line" do
    user = FactoryGirl.create(:user)
    visit new_user_session_path

    within("#new_user") do
      fill_in "Email", with: user.email
      fill_in "Password", with: user.password
      click_button "Log in"
    end

    visit new_line_path
    fill_in "name", with: 'Proposal'
    fill_in "Hello", with: 'Proposal'
    click_on 'Submit'

    expect(current_path).to eq lines_path
    expect(page).to have_content("Proposal")
  end
end
