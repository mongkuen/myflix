require 'spec_helper'

describe Category do
  it { should have_many(:videos) }
  it { should validate_presence_of(:name) }

  describe "#recent_videos" do
    it "returns the videos in the reverse chronological order by created_at" do
      video_category = Category.create(name: "Mystery")
      old_video = Video.create(title: "Video Old", description: "Old Video", category: video_category, created_at: 1.day.ago)
      new_video = Video.create(title: "Video Recent", description: "Video Description", category: video_category)

      expect(video_category.recent_videos).to eq([new_video, old_video])
    end

    it "returns all videos if less than 6 videos" do
      video_category = Category.create(name: "Mystery")
      old_video = Video.create(title: "Video Old", description: "Old Video", category: video_category, created_at: 1.day.ago)
      new_video = Video.create(title: "Video Recent", description: "Video Description", category: video_category)

      expect(video_category.recent_videos.count).to eq(2)
    end

    it "returns 6 videos if there are 6 or more videos" do
      video_category = Category.create(name: "Mystery")
      7.times do
        Video.create(title: "Video Recent", description: "Video Description", category: video_category)
      end
      expect(video_category.recent_videos.count).to eq(6)
    end

    it "returns the most recent 6 videos" do
      video_category = Category.create(name: "Mystery")
      old_video = Video.create(title: "Video Old", description: "Old Video", category: video_category, created_at: 1.day.ago)
      6.times do
        Video.create(title: "Video Recent", description: "Video Description", category: video_category)
      end
      expect(video_category.recent_videos).not_to include(old_video)
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

  describe "#selection" do
    it "returns empty array if there are no categories" do
      expect(Category.selection).to eq([])
    end

    it "returns all categories with their ids" do
      category_1 = Fabricate(:category)
      category_2 = Fabricate(:category)
      expect(Category.selection).to eq([[category_1.name, category_1.id], [category_2.name, category_2.id]])
    end
  end

end
