require 'spec_helper'

feature 'Video add and watch' do
  scenario "Admin adds and user watches video" do
    admin = Fabricate(:user, role: 1)
    category = Fabricate(:category)

    log_in(admin)
    admin_adds_video
    expect_redirect_new_admin_video
    logout

    log_in
    visit_video
    expect_watch_link_present
  end
end

def admin_adds_video
  visit new_admin_video_path
  fill_in 'Title', with: 'Storage Wars'
  select "#{Category.first.name}", from: 'video_category_id'
  fill_in 'Description', with: 'Storage is serious business.'
  attach_file 'Large Cover', Rails.root.join('spec/fabricators/fixtures/large_cover.jpg')
  attach_file 'Small Cover', Rails.root.join('spec/fabricators/fixtures/small_cover.jpg')
  fill_in 'Video URL', with: "www.videourl.com"
  click_on 'Add Video'
end

def expect_redirect_new_admin_video
  expect(Video.count).to eq(1)
  expect(page).to have_content('Add a New Video')
end

def visit_video
  click_on "Videos"
  video = Video.first
  find(:xpath, "//a[@href='/videos/#{video.id}']").click
  expect(page).to have_content("#{video.title}")
end

def expect_watch_link_present
  video_url = find(:xpath, "//a[@href='www.videourl.com']")
  expect(video_url).to be_truthy
end
