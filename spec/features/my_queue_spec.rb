require 'spec_helper'

feature "My Queue" do
  scenario "clicks video to my queue" do
    user = Fabricate(:user)
    category = Fabricate(:category)
    video = Fabricate(:video, category: category)
    video_2 = Fabricate(:video, category: category)
    video_3 = Fabricate(:video, category: category)

    sign_in(user)

    add_video_to_queue(video)

    expect_title_on_page(video)

    click_on video.title
    expect_title_on_page(video)
    expect_not_on_page("+ My Queue")

    add_video_to_queue(video_2)
    add_video_to_queue(video_3)

    set_video_position(video, 3)
    set_video_position(video_2, 2)
    set_video_position(video_3, 1)

    click_on "Update Instant Queue"

    expect_video_position(video, 3)
    expect_video_position(video_2, 2)
    expect_video_position(video_3, 1)
  end

  private
  def sign_in(user)
    visit '/login'
    fill_in "Email Address", with: user.email
    fill_in "Password", with: user.password
    click_on "Sign In"
  end

  def add_video_to_queue(video)
    click_on "Videos"
    find(:xpath, "//a[@href='/videos/#{video.id}']").click
    click_on "+ My Queue"
  end

  def expect_title_on_page(video)
    expect(page).to have_content video.title
  end

  def expect_not_on_page(text)
    expect(page).not_to have_content text
  end

  def set_video_position(video, position)
    find("input[data-video-id='#{video.id}']").set(position)
  end

  def expect_video_position(video, position)
    expect(find("input[data-video-id='#{video.id}']").value).to eq("#{position}")
  end


end
