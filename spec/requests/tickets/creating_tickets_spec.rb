require 'spec_helper'

feature "Creating Tickets" do
  before do
    FactoryGirl.create(:project, :name => "Internet Explorer")
    user = FactoryGirl.create(:user, :email => "ticketee@example.com")
    user.confirm!

    visit "/"
    click_link "Internet Explorer"
    click_link "New Ticket"
    message = "You need to sign in or sign up before continuing"
    page.should have_content(message)

    fill_in "Email", :with => 'ticketee@example.com'
    fill_in "Password", :with => "password"
    click_button "Sign in"
    within("h2") { page.should have_content("New Ticket") }
  end

  scenario "Creating a ticket" do
    fill_in "Title", :with => "Non-standards compliance"
    fill_in "Description", :with => "My pages are ugly!"
    click_button "Create Ticket"
    page.should have_content("Ticket has been created.")
    within("#ticket #author") do
      page.should have_content('Created by ticketee@example.com')
    end
  end

  scenario "Creating a ticket without valid attributes fails" do
    click_button "Create Ticket"
    page.should have_content("Ticket has not been created.")
    page.should have_content("Title can't be blank")
    page.should have_content("Description can't be blank")
  end

  scenario "Description must be greater than 10 characters" do
    fill_in "Title", :with => "Non-standards compliance"
    fill_in "Description", :with => "It sucks"
    click_button "Create Ticket"
    page.should have_content("Ticket has not been created.")
    page.should have_content("Description is too short")
  end
end
