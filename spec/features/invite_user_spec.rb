require 'spec_helper'

feature "Invite User" do
  scenario "Invitor invites user" do
    invitor = Fabricate(:user)
    log_in(invitor)
    click_invite_friends
    fill_and_submit_invite
    expect_invite_sent
    click_email_invite_link
    expect_prefilled_register_form
    fill_and_submit_registration
    expect_leaders_present
  end

end

def click_invite_friends
  click_on "Invite Friends"
end

def fill_and_submit_invite
  fill_in "Friend's Name", with: "Adam Apple"
  fill_in "Friend's Email Address", with: "adam@adam.com"
  fill_in "Invitation Message", with: "Join MyFlix!"
  click_on "Send Invitation"
end

def expect_invite_sent
  expect(page).to have_content("Your invitation was sent!")
end

def click_email_invite_link
  open_email("adam@adam.com")
  current_email.click_on "Sign up for Myflix"
end

def expect_prefilled_register_form
  expect(page).to have_content("Register")
  expect(page).to have_selector("input[value='Adam Apple']")
  expect(page).to have_selector("input[value='adam@adam.com']")
end

def fill_and_submit_registration
  fill_in "Password", with: "password"
  click_on "Sign Up"
end

def expect_leaders_present
  expect(page).to have_content("Adam Apple")
  click_on "People"
  expect(page).to have_content(User.first.full_name)
end
