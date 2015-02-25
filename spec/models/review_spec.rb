require 'spec_helper'

describe Review do
  it { should validate_presence_of(:rating) }
  it { should validate_presence_of(:review) }
  it { should belong_to(:user) }
  it { should belong_to(:video) }

  it "should return reviews by most recent reviews first" do
    video = Fabricate(:video)
    old_review = Fabricate(:review, video: video, created_at: 10.day.ago)
    new_review = Fabricate(:review, video: video, created_at: 1.day.ago)
    expect(Video.first.reviews).to eq([new_review, old_review])
  end

end
