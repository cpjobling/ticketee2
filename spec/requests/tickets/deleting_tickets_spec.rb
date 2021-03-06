require 'spec_helper'

feature "Deleting tickets"  do
  let!(:project) { FactoryGirl.create(:project) }
  let!(:user)    { FactoryGirl.create(:confirmed_user) }
  let!(:ticket) do
    ticket = FactoryGirl.create(:ticket, :project => project)
    ticket.update_attribute(:user, user)
    ticket
  end

  before do
    sign_in_as!(user)
    visit "/"
    click_link project.name
    click_link ticket.title
    click_link "Edit Ticket"
  end
  before do
    visit '/'
    click_link project.name
    click_link ticket.title
  end

  scenario "Deleting a ticket" do
    click_link "Delete Ticket"
    page.should have_content("Ticket has been deleted.")
    page.current_url.should == project_url(project)
    page.should_not have_content(ticket.title)
  end
end