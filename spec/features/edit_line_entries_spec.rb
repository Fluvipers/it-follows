require 'rails_helper'

feature "Editing line entries" do
  let(:user) { FactoryGirl.create(:user) }
  let(:yoko) { FactoryGirl.create(:user, email: 'yoko@gmail.com') }

  context "when a user is logged in" do
    context "and the line exists" do
      context "and if user is owner of the line" do
        scenario "user can edit the line" do
          line = user.lines.create!(name: 'Support Tickets',
            properties: [Property.new(name: 'Title')])
          title = 'new test line'
          line_entry = user.line_entries.create!(line: line, data: {title: title})
  
          visit new_user_session_path
  
          within("#new_user") do
            fill_in "Email", with: user.email
            fill_in "Password", with: user.password
            click_button "Log in"
          end
  
          visit "/support_tickets/#{line_entry.id}/edit"

          expect(current_path).to eq "/support_tickets/#{line_entry.id}/edit"
          expect(page).to have_selector("input[value='" + title + "']")
          expect(page).to have_selector("input[type=submit]")
        end
      end

      context "and if user is tagged on the line" do
        scenario "user can edit the line" do
          line = user.lines.create!(name: 'Support Tickets',
            properties: [Property.new(name: 'Title')])
          line_entry = user.line_entries.create!(line: line, data: {title: 'algo'})
          followup = line_entry.followups.create!(description: "do something with @#{yoko.screen_name}", percentage: 0)

          visit new_user_session_path

          within("#new_user") do
            fill_in "Email", with: yoko.email
            fill_in "Password", with: yoko.password
            click_button "Log in"
          end

          visit "/support_tickets/#{line_entry.id}/edit"

          expect(current_path).to eq "/support_tickets/#{line_entry.id}/edit"
          expect(page).to have_content(followup.description)
        end
      end
    end
    context "and user isn't tagged on the line" do
      scenario "user can't edit the line" do
        line = user.lines.create!(name: 'Support Tickets',
          properties: [Property.new(name: 'Title')])
        line_entry = user.line_entries.create!(line: line, data: {title: 'algo'})

        visit new_user_session_path

        within("#new_user") do
          fill_in "Email", with: yoko.email
          fill_in "Password", with: yoko.password
          click_button "Log in"
        end

        visit "/support_tickets/#{line_entry.id}/edit"

        expect(page.status_code).to eq 403
        expect(page).to have_content("The page you were looking for doesn't exist.")
      end
    end
  end
end
