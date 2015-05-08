require 'spec_helper'

feature "User Authentication" do
  let(:user) { Fabricate(:user) }

  scenario "User signs in" do
    visit '/login'
    fill_in "Email Address", with: user.email
    fill_in "Password", with: user.password
    click_on "Sign In"
    expect(page).to have_content user.full_name
  end
end
