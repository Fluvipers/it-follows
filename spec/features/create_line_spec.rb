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

    expect(Property.count).to eq 0

    visit new_line_path
    fill_in "name", with: 'Proposal'
    fill_in "line_properties_attributes_0_name", with: 'New Property'
    check "line_properties_attributes_0_required"
    click_on 'Submit'

    expect(current_path).to eq lines_path
    expect(page).to have_content("Proposal")
    expect(Property.count).to eq 2
    expect(Property.first.name).to eq "New Property"
    expect(Property.first.required).to eq true
    expect(Property.last.required).to eq true

    visit '/proposal'

    expect(current_path).to eq '/proposal'

    click_link 'New'

    expect(page).to have_content("Name")
    expect(page).to have_content("New Property")
  end
end
