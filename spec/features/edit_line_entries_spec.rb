require 'rails_helper'

feature "Editing line intries" do
  let(:user) { FactoryGirl.create(:user) }
  let(:yoko) { FactoryGirl.create(:user, email: 'yoko@gmail.com', screen_name: 'yoko') }
  let(:line) { user.lines.create!(name: "Tickets", properties: [{name: "Title"}]) }

  context "when a user is logged in" do
    context "and the line exists" do
      context "and if user is owner of the line" do
        scenario "user can edit the line" do
        line = user.lines.create!(name: 'Support Tickets',
          properties: [{name: 'Title', required: false}])
        line_entry = user.line_entries.create!(line: line, data: {title: 'algo'})

        visit new_user_session_path

        within("#new_user") do
          fill_in "Email", with: user.email
          fill_in "Password", with: user.password
          click_button "Log in"
        end

        visit "/support_tickets/#{line_entry.id}/edit"
        expect(current_path).to eq "/support_tickets/#{line_entry.id}/edit"
        end
      end

      context "and if user is tagged on the line" do
        scenario "user can edit the line" do
        line = user.lines.create!(name: 'Support Tickets',
          properties: [{name: 'Title', required: true}])
        line_entry = user.line_entries.create!(line: line, data: {title: 'algo'})
        line_entry.followups.create!(description: 'do something with @yoko', percentage: 0)

        visit new_user_session_path

        within("#new_user") do
          fill_in "Email", with: yoko.email
          fill_in "Password", with: yoko.password
          click_button "Log in"
        end

        visit "/support_tickets/#{line_entry.id}/edit"
        expect(current_path).to eq "/support_tickets/#{line_entry.id}/edit"
        end
      end
    end
    context "and user isn't tagged on the line" do
      scenario "user can't edit the line" do
        line = user.lines.create!(name: 'Support Tickets',
          properties: [{name: 'Title', required: true}])
        line_entry = user.line_entries.create!(line: line, data: {title: 'algo'})

        visit new_user_session_path

        within("#new_user") do
          fill_in "Email", with: yoko.email
          fill_in "Password", with: yoko.password
          click_button "Log in"
        end

        visit "/support_tickets/#{line_entry.id}/edit"
        expect(page.status_code).to eq 403
      end
    end
  end
end
