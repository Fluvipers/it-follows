require 'rails_helper'

feature "Editing line entries" do
  let(:user) { FactoryGirl.create(:user, role: "Admin") }
  let(:yoko) { FactoryGirl.create(:user, email: 'yoko@gmail.com', role: "it_followers", first_name: "Yoko", last_name: "No se sabe") }

  context "when a user is logged in" do
    context "and the role is Admin" do
      scenario "must find navbar" do
        my_no_admin_line = user.lines.create!(name: 'Line 2', properties: [Property.new(name: 'Title')])
        my_admin_line =  user.lines.create!(name: 'Line 1', properties: [Property.new(name: 'Title')])

        visit "/#{my_admin_line.slug_name}?token=#{user.authentication_token}"

        expect(page).not_to have_content(yoko.full_name)
        expect(page).not_to have_content("@#{yoko.screen_name}")
        expect(page).not_to have_content(yoko.email)
        expect(page).to have_content(user.full_name)
        expect(page).to have_content("@#{user.screen_name}")
        expect(page).to have_content(user.email)

        expect(page).to have_content(my_admin_line.name)
        expect(page).to have_content(my_no_admin_line.name)
      end
    end

    context "and the role is not Admin" do
      scenario "mustn't find navbar" do
        my_no_admin_line = user.lines.create!(name: 'Line 2', properties: [Property.new(name: 'Title')]) 
        my_admin_line =  user.lines.create!(name: 'Line 1', properties: [Property.new(name: 'Title')])

        visit "/#{my_no_admin_line.slug_name}?token=#{yoko.authentication_token}"

        expect(page).to have_content(yoko.full_name)
        expect(page).to have_content("@#{yoko.screen_name}")
        expect(page).to have_content(yoko.email)
        expect(page).not_to have_content(user.full_name)
        expect(page).not_to have_content("@#{user.screen_name}")
        expect(page).not_to have_content(user.email)

        expect(page).not_to have_content(my_admin_line.name)
        expect(page).not_to have_content(my_no_admin_line.name)
      end
    end
  end

  context "when a user is not logged in" do
    let(:my_line) { yoko.lines.create!(name: 'Support Tickets', properties: [Property.new(name: 'Title')]) }
    let(:my_line_entry) { user.line_entries.create!(line: my_line, data: {title: "new line entry"}) }

    context "and the request has valid token" do
      scenario "let visit path" do
        visit "/#{my_line.slug_name}/#{my_line_entry.id}/edit?token=#{yoko.authentication_token}"
        expect(current_path).to eq "/support_tickets/#{my_line_entry.id}/edit"
        expect(page).to have_content(my_line_entry.data[:title])
      end
    end

    context "and the request has not valid token" do
      scenario "mustn't visit path" do
        visit "/#{my_line.slug_name}/#{my_line_entry.id}/edit?token=jsdhfkdhfsklhd"
        expect(current_path).to eq new_user_session_path
        expect(page).to have_content("Log in")
      end
    end

    context "and the request has not token" do
      scenario "mustn't visit path" do
        visit "/#{my_line.slug_name}/#{my_line_entry.id}/edit"
        expect(page).to have_content("Log in")
      end
    end
  end

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

          fill_in "line_entry_followups_attributes_0_description", with: 'Followup Creado por otro'
          fill_in "line_entry_followups_attributes_0_percentage", with: 2
          click_button "Submit"

          expect(current_path).to eq "/support_tickets/#{line_entry.id}/edit"
          expect(page).to have_content('Followup Creado por otro')
        end
      end

      context "and if user is tagged on task" do
        scenario "user can edit the line" do
          line = user.lines.create!(name: 'Support Tickets',
            properties: [Property.new(name: 'Title')])
          line_entry = user.line_entries.create!(line: line, data: {title: 'algo'})
          followup = line_entry.followups.create!(description: "do something", percentage: 0, user: user)
          task = line_entry.followups.last.tasks.create!(user_id: user.id, description: "do something with @#{yoko.screen_name}")

          visit new_user_session_path

          within("#new_user") do
            fill_in "Email", with: yoko.email
            fill_in "Password", with: yoko.password
            click_button "Log in"
          end

          visit "/support_tickets/#{line_entry.id}/edit"

          expect(current_path).to eq "/support_tickets/#{line_entry.id}/edit"
          expect(page).to have_content(followup.description)

          fill_in "line_entry_followups_attributes_0_description", with: 'Followup Creado por otro'
          fill_in "line_entry_followups_attributes_0_percentage", with: 2
          click_button "Submit"

          expect(current_path).to eq "/support_tickets/#{line_entry.id}/edit"
          expect(page).to have_content('Followup Creado por otro')
        end
      end

      context "and if user is tagged on the line" do
        scenario "user can edit the line" do
          line = user.lines.create!(name: 'Support Tickets',
            properties: [Property.new(name: 'Title')])
          line_entry = user.line_entries.create!(line: line, data: {title: 'algo'})
          followup = line_entry.followups.create!(description: "do something with @#{yoko.screen_name}", percentage: 0, user: user)

          visit new_user_session_path

          within("#new_user") do
            fill_in "Email", with: yoko.email
            fill_in "Password", with: yoko.password
            click_button "Log in"
          end

          visit "/support_tickets/#{line_entry.id}/edit"

          expect(current_path).to eq "/support_tickets/#{line_entry.id}/edit"
          expect(page).to have_content(followup.description)

          fill_in "line_entry_followups_attributes_0_description", with: 'Followup Creado por otro'
          fill_in "line_entry_followups_attributes_0_percentage", with: 2
          click_button "Submit"

          expect(current_path).to eq "/support_tickets/#{line_entry.id}/edit"
          expect(page).to have_content('Followup Creado por otro')
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
        expect(page).to have_content("You are not authorized to view this page (403)")
      end
    end
  end
end
