require 'rails_helper'

feature "Create a new line entry and enter followups for that entry" do
  before do
    user = FactoryGirl.create(:user)
    @line1 = user.lines.create!(name: 'Support Tickets')
    property11 = @line1.properties.create!(name: 'Title', required: true)
    property12 = @line1.properties.create!(name: 'Advertiser', required: true)
 
    @line2 = user.lines.create!(name: 'Influencers commits')
    property21 = @line2.properties.create!(name: 'id', required: true)
    property22 = @line2.properties.create!(name: 'screen_name', required: true)

    @my_line_entry11 = user.line_entries.create!(line: @line1, data: { advertiser: "Lecheria", title: "Presupuesto", name: "Colanta" })
    @my_line_entry12 = user.line_entries.create!(line: @line1, data: { advertiser: "Gaseosa", title: "Presupuesto", name: "Coke" })

    @my_line_entry31 = user.line_entries.create!(line: @line2, data: { screen_name: "Maria", id: "13", name: "manvedu" })
    @my_line_entry32 = user.line_entries.create!(line: @line2, data: { screen_name: "eliecer", id: "45", name: "ladilla" })
    @my_line_entry33 = user.line_entries.create!(line: @line2, data: { screen_name: "rocio", id: "34", name: "padilla" })
    @my_line_entry34 = user.line_entries.create!(line: @line2, data: { screen_name: "don", id: "89", name: "ardilla" })

    visit new_user_session_path

    within("#new_user") do
      fill_in "Email", with: user.email
      fill_in "Password", with: user.password
      click_button "Log in"
    end
  end

  context "When there are two lines" do
    context "and I search for some data in data propertie in line_entry" do
      scenario "should find line_entries with that data for my respectly line" do

        visit "/#{@line1.slug_name}"
        fill_in "search[search]", with: "Presupuesto"
        click_button "Save Search"
        expect(page).to have_content("Colanta")
        expect(page).to have_content("Coke")

        fill_in "search[search]", with: "Coke"
        click_button "Save Search"
        expect(page).to_not have_content("Colanta")
        expect(page).to have_content("Coke")

        fill_in "search[search]", with: "manvedu"
        click_button "Save Search"
        expect(page).to_not have_content("Colanta")
        expect(page).to_not have_content("Coke")

        visit "/#{@line2.slug_name}"
        fill_in "search[search]", with: "Presupuesto"
        click_button "Save Search"
        expect(page).to_not have_content("Colanta")
        expect(page).to_not have_content("Coke")

        fill_in "search[search]", with: "Colanta"
        click_button "Save Search"
        expect(page).to_not have_content("Colanta")
        expect(page).to_not have_content("Coke")

        fill_in "search[search]", with: "padilla"
        click_button "Save Search"
        expect(page).to_not have_content("Colanta")
        expect(page).to_not have_content("Coke")
        expect(page).to_not have_content("ladilla")
        expect(page).to_not have_content("ardilla")
        expect(page).to_not have_content("manvedu")

      end
    end
  end
end

feature "Create a new line entry and enter followups for that entry" do
  let (:user) { user = FactoryGirl.create(:user) }
  context "When there is a line called 'Support tickets' available on the nav menu" do
    context "As a logged user" do
      scenario "I want create a new Proposal but I don't set some field" do

        line = user.lines.create!(name: 'Support Tickets')
        property = line.properties.create!(name: 'Title', required: true)
        property2 = line.properties.create!(name: 'Advertiser', required: true)
        property3 = line.properties.create!(name: 'Client', required: true)

        visit new_user_session_path

        within("#new_user") do
          fill_in "Email", with: user.email
          fill_in "Password", with: user.password
          click_button "Log in"
        end

        visit '/support_tickets'

        expect(current_path).to eq '/support_tickets'
        expect(Line.last.line_entries.count).to   eq(0)

        click_on 'New'

        expect(current_path).to eq '/support_tickets/new'

        within("#line-entry-form") do
          fill_in 'Title', with: ''
          fill_in 'Advertiser', with: ''
          fill_in 'Client', with: ''
          click_on 'Submit'
        end

        expect(Line.last.line_entries.count).to   eq(0)
        expect(page).to have_content("There's some fields without data.")
        expect(current_path).to eq '/support_tickets/new'

      end
    end
  end

  context "When there is a line called 'Support tickets' available on the nav menu" do
    context "As a logged user" do
      scenario "I create a new Proposal and add followups for tha proposal" do
        file_path = File.expand_path('../../../spec/fixtures', __FILE__)

        expect(Property.count).to eq 0

        line = user.lines.create!(name: 'Support Tickets')
        property = line.properties.create!(name: 'Title', required: true)
        property2 = line.properties.create!(name: 'Advertiser', required: true)
        property3 = line.properties.create!(name: 'Client', required: true)
        expect(Property.count).to eq 4

        visit new_user_session_path

        within("#new_user") do
          fill_in "Email", with: user.email
          fill_in "Password", with: user.password
          click_button "Log in"
        end

        visit '/support_tickets'

        expect(current_path).to eq '/support_tickets'

        click_on 'New'

        expect(current_path).to eq '/support_tickets/new'

        within("#line-entry-form") do
          expect(page).to_not have_selector("#followups")

          fill_in 'Name', with: 'New proposal name'
          fill_in 'Title', with: 'A new novel proposal'
          fill_in 'Advertiser', with: 'Havas'
          fill_in 'Client', with: 'Cocacola'
          click_on 'Submit'
        end

        visit '/support_tickets'

        expect(current_path).to eq '/support_tickets'

        expect(page).to have_content("New")
        expect(page).to have_content("wendy")
        expect(page).to have_content("0%")

        expect(line.line_entries.count).to eq 1

        line_entry = line.line_entries.first

        expect(line_entry.data["title"]).to eq "A new novel proposal"
        expect(line_entry.data["advertiser"]).to eq "Havas"
        expect(line_entry.data["client"]).to eq "Cocacola"

        within("table tbody tr:first") do
          click_on "Edit"
        end

        expect(current_path).to eq "/support_tickets/#{line_entry.id}/edit"

        within("#line-entry-form") do
          expect(page).to have_selector("#followups")

          expect(page.find_field("Title").value).to eq "A new novel proposal"
          expect(page.find_field("Advertiser").value).to eq "Havas"
          expect(page.find_field("Client").value).to eq "Cocacola"

          fill_in 'Title', with: 'New title'
          fill_in 'Advertiser', with: 'new advertiser'
          fill_in 'Client', with: 'new client'
        end

        within("#followups") do
          fill_in 'Activity details', with: '@dave and I visited the client, they need #sports and #fashion'
          fill_in 'Completion percentage', with: '10'
          find("#line_entry_followups_attributes_0_tasks").set("call the client")
          attach_file('Attachments', "#{Rails.root}/image.jpg")
        end

        click_on 'Submit'

        line_entry.reload

        expect(line_entry.data["title"]).to eq "New title"
        expect(line_entry.data["advertiser"]).to eq "new advertiser"
        expect(line_entry.data["client"]).to eq "new client"

        expect(line_entry.followups.count).to eq 1
        followup = line_entry.followups.first
        expect(followup.user).to eq user
        expect(followup.tasks.count).to eq 1
        task = followup.tasks.first
        expect(task.description).to eq "call the client"
        expect(task.user).to eq user

        expect(followup.attached_documents.count).to eq 1
        expect(page).to have_link("#{followup.attached_documents.last.document.file.filename}")
        attachment = followup.attached_documents.first

        expect(attachment.document.url).to eq "/uploads/attached_document/document/#{attachment.id}/image.jpg"

        expect(current_path).to eq "/support_tickets/#{line_entry.id}/edit"

        within("#mentions") do
          expect(page).to have_link("@dave")
        end

        within("#tags") do
          expect(page).to have_link("#sports")
          expect(page).to have_link("#fashion")
        end

        within("#followups") do
          expect(page).to have_content(followup.description)
          expect(page).to have_content("#{followup.percentage}%")
        end

        within("#followups") do
          fill_in 'Activity details', with: '@dave and I visited the client, they need #sports and #fashion'
          fill_in 'Completion percentage', with: '10'
          find("#line_entry_followups_attributes_0_tasks").set("\nTarea 1\n\n\n \nTarea 2")
          attach_file('Attachments', "#{Rails.root}/image.jpg")
        end

        click_on 'Submit'

        line_entry.reload

        expect(line_entry.followups.count).to eq 2
        followup = line_entry.followups.last
        expect(followup.tasks.count).to eq 2
        task = followup.tasks.first
        expect(task.description).to eq "Tarea 1"
        task = followup.tasks.last
        expect(task.description).to eq "Tarea 2"

        visit '/support_tickets'

        expect(current_path).to eq '/support_tickets'

        expect(page).to have_content("wendy")
        expect(page).to have_content("10%")
      end
    end

    context "as an anonymous user" do
      scenario "I should not be able to create new line entries" do
        user = User.create!(first_name: 'wendy', last_name: 'darling', email: 'wendy@gmail.com',
          password: '12345678', password_confirmation: '12345678', confirmed_at: Time.now)
        line = user.lines.create!(name: 'Proposals')
        visit root_path
        expect(current_path).to eq new_user_session_path
      end
    end

    context "as an anonymous user" do
      scenario "I should not be able to create new line entries" do
        user = User.create!(first_name: 'wendy', last_name: 'darling', email: 'wendy@gmail.com',
          password: '12345678', password_confirmation: '12345678', confirmed_at: Time.now)
        line = user.lines.create!(name: 'Proposals')
        visit root_path
        expect(current_path).to eq new_user_session_path
      end
    end
  end
end
