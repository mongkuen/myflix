require 'spec_helper'

describe Category do
  it { should have_many(:videos) }
  it { should validate_presence_of(:name) }

  describe "#recent_videos" do
    it "returns the videos in the reverse chronological order by created_at" do
      category = Fabricate(:category)
      old_video = Fabricate(:video, category: category, created_at: 1.day.ago)
      new_video = Fabricate(:video, category: category)
      expect(category.recent_videos).to eq([new_video, old_video])
    end

    it "returns all videos if less than 6 videos" do
      category = Fabricate(:category)
      old_video = Fabricate(:video, category: category, created_at: 1.day.ago)
      new_video = Fabricate(:video, category: category)
      expect(category.recent_videos.count).to eq(2)
    end

    it "returns 6 videos if there are 6 or more videos" do
      category = Fabricate(:category)
      7.times do
        Fabricate(:video, category: category)
      end
      expect(category.recent_videos.count).to eq(6)
    end

    it "returns the most recent 6 videos" do
      category = Fabricate(:category)
      old_video = Fabricate(:video, category: category, created_at: 1.day.ago)
      6.times do
        Fabricate(:video, category: category)
      end
      expect(category.recent_videos).not_to include(old_video)
    end

    it "returns an empty array if the category does not have any videos" do
      video_category = Category.create(name: "Mystery")
      expect(video_category.recent_videos).to eq([])
    end

    # it "gets the most recent 6 videos inside category" do
    #   video_category = Category.create(name: "Mystery")
    #   old_video = Video.create(title: "Video Old", description: "Old Video", category: video_category, created_at: 1.day.ago)
    #   6.times do
    #     Video.create(title: "Video Recent", description: "Video Description", category: video_category)
    #   end
    #   expect(video_category.recent_videos.where(title: "Video Recent").count).to eq(6)
    # end

  end
end
