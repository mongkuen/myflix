require 'spec_helper'

feature "Social Networking feature" do
  scenario "User follows a person and unfollows" do
    user = Fabricate(:user)
    user_2 = Fabricate(:user)
    category = Fabricate(:category)
    video = Fabricate(:video, category: category)
    review = Fabricate(:review, user: user_2, video: video)

    log_in(user)
    click_video(video)
    click_user_review(user_2)
    click_on "Follow"
    click_on "People"
    expect_user_in_list(user_2)
    click_remove
    expect_user_not_in_list(user_2)
  end
end

def click_video(video)
  find("a[href='/videos/#{video.id}']").click
end

def click_user_review(user)
  click_on user.full_name
end

def expect_user_in_list(user)
  expect(page).to have_content user.full_name
end

def click_remove
  find("a[href='/followerships/#{Followership.first.id}']").click
end

def expect_user_not_in_list(user)
  expect(page).not_to have_content user.full_name
end
