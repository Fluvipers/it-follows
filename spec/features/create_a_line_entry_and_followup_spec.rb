require 'rails_helper'
#Rails.application.routes.draw { resources :cosas, except: [:destroy], controller: 'line_entries' }

feature "Create a new line entry and enter followups for that entry" do
  context "When there is a line called 'Proposals' available on the nav menu" do
    context "As a logged user" do
      scenario "I create a new Proposal and add followups for tha proposal" do
        file_path = File.expand_path('../../../spec/fixtures', __FILE__)
        user = User.create!(first_name: 'wendy', last_name: 'darling', email: 'wendy@gmail.com',
          password: '12345678', password_confirmation: '12345678', confirmed_at: Time.now)

        line = user.lines.create!(name: 'Proposals')

        visit new_user_session_path

        within("#new_user") do
          fill_in "Email", with: user.email
          fill_in "Password", with: '12345678'
          click_button "Log in"
        end

        within(".nav") do
          click_on 'Proposals'
        end

        expect(current_path).to eq '/proposals'

        click_on 'New'

        expect(current_path).to eq '/proposals/new'

        within("#line-entry-form") do
          expect(page).to_not have_selector("#followups")

          fill_in 'Title', with: 'A new novel proposal'
          fill_in 'Advertiser', with: 'Havas'
          fill_in 'Client', with: 'Cocacola'
          click_on 'Submit'
        end

        expect(line.line_entries.count).to eq 1
        line_entry = line.line_entries.first

        expect(line_entry.title).to eq "A new novel proposal"

        expect(current_path).to eq "/proposals/#{line_entry.id}/edit"

        within("#line-entry-form") do
          expect(page).to have_selector("#followups")

          # The title should be in the page but cannot be changed
          expect(page).to have_content("A new novel proposal")
          expect(page).to_not have_selector("input[name='title']")
        end

        within("#followups") do
          fill_in 'Activity details', with: '@dave and I visited the client, they need #sports and #fashion'
          fill_in 'Completion percentage', with: '10'
          find("#line_entry_followups_attributes_0_tasks").set("call the clientxxsend printed proposal")
          attach_file('Attachments', "#{file_path}/minute.doc")
        end

        click_on 'Submit'

        line_entry.reload
        expect(line_entry.followups.count).to eq 1
        followup = line_entry.followups.first
        expect(followup.tasks.count).to eq 2
        task = followup.tasks.first
        expect(task.description).to eq "call the client"

        expect(followup.documents.count).to eq 1
        attachment = followup.documents.first
        expect(attachment["original_filename"]).to eq 'minute.doc'

        expect(current_path).to eq "/proposals/#{line_entry.id}/edit"

        within("#mentions") do
          expect(page).to have_link("@dave")
        end

        within("#tags") do
          expect(page).to have_link("#sports")
          expect(page).to have_link("#fashion")
        end

        within(".nav") do
          click_on 'Proposals'
        end

        expect(current_path).to eq '/proposals'

        expect(page).to have_content("A new novel proposal")
        expect(page).to have_content("wendy")
        expect(page).to have_content("10%")
      end
    end
  end
end