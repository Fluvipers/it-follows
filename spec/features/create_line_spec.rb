require 'rails_helper'

feature "Define a new Line", type: :feature do
  scenario "I create a new line" do
    visit new_line_path
    fill_in "name", with: 'Proposal'
    click_on 'Submit'

    expect(current_path).to eq lines_path
    expect(page).to have_content("Proposal")
  end
end
