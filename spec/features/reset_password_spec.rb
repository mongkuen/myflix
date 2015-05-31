require 'spec_helper'

feature "reset password" do
  scenario "user uses email password reset" do
    user = Fabricate(:user)
    visit_forgot_password
    fill_and_submit_reset
    expect_confirmation
    click_email_reset_link
    fill_and_submit_new_password
    fill_and_submit_new_login
    expect_login
  end
end

def visit_forgot_password
  visit root_path
  click_on "Sign In"
  click_on "Forgot Password?"
end

def fill_and_submit_reset
  fill_in "Email Address", with: User.first.email
  click_on "Send Email"
end

def expect_confirmation
  expect(current_path).to eq(confirmation_path)
end

def click_email_reset_link
  open_email(User.first.email)
  current_email.click_on "Reset My Password"
end

def fill_and_submit_new_password
  fill_in "New Password", with: "password"
  click_on "Reset Password"
end

def fill_and_submit_new_login
  fill_in "Email Address", with: User.first.email
  fill_in "Password", with: "password"
  click_on "Sign In"
end

def expect_login
  expect(page).to have_content(User.first.full_name)
end
