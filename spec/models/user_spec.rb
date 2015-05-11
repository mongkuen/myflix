require 'spec_helper'

describe User do
  it { should validate_presence_of(:full_name) }
  it { should validate_presence_of(:email) }
  it { should validate_uniqueness_of(:email) }
  it { should have_many(:reviews).order("created_at DESC") }
  it { should have_many(:queue_items).order(:position) }

  describe "#user_queued_video?" do
    it "returns true if user has queued video" do
      user = Fabricate(:user)
      video = Fabricate(:video)
      queue_item = Fabricate(:queue_item, user: user, video: video)
      expect(user.user_queued_video?(video)).to eq(true)
    end

    it "returns false if user has not queued video" do
      user = Fabricate(:user)
      video = Fabricate(:video)
      video_2 = Fabricate(:video)
      queue_item = Fabricate(:queue_item, user: user, video: video)
      expect(user.user_queued_video?(video_2)).to eq(false)
    end
  end
end
