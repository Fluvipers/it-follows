require 'rails_helper'
#Rails.application.routes.draw { resources :cosas, except: [:destroy], controller: 'line_entries' }

feature "Create a new line entry and enter followups for that entry" do
  context "When there is a line called 'Proposals' available on the nav menu" do
    context "As a logged user" do
      scenario "I create a new Proposal and add followups for tha proposal" do
        file_path = File.expand_path('../../../fixtures', __FILE__)
        user = User.create!(first_name: 'Jhon', last_name: 'Smith', email: 'wendy@gmail.com',
          password: '12345678', password_confirmation: '12345678', confirmed_at: Time.now)

        user.lines.create!(name: 'Proposals')

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

        expect(current_path).to eq '/proposals/a-new-novel-proposal/edit'

        within("#line-entry-form") do
          expect(page).to have_selector("#followups")

          # The title should be in the page but cannot be changed
          expect(page).to have_content("A new novel proposal")
          expect(page).to_not have_selector("input[name='title']")
        end

        within("#followups") do
          fill_in 'Activity details', with: '@dave and I visited the client, they need #sports and #fashion'
          fill_in 'Tasks', with: 'call the client\nsend printed proposal'
          fill_in 'Completion percentage', with: '10'
          attach_file('Attachments', "#{file_path}/minute.doc")
          click_on 'Submit'
        end

        expect(current_path).to eq 'proposals/a-new-novel-proposal'

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

        expect(current_path).to eq 'proposals'

        expect(page).to have_content("A new novel proposal")
        expect(page).to have_content("wendy")
        expect(page).to have_content("10%")
      end
    end
  end
end
