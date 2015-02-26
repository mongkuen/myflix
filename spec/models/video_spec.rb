require'spec_helper'

describe Video do
  it { should belong_to(:category) }
  it { should have_many(:reviews) }
  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:description) }

  describe "search_by_title" do
    it "returns an empty array if there is no match" do
      video1 = Video.create(title: "Family Guy", description: "Edgy comedy")
      video2 = Video.create(title: "Family Feud", description: "Game show")
      video3 = Video.create(title: "Futurama", description: "Fry has no family")
      expect(Video.search_by_title("Doesn't exist")).to eq([])
    end

    it "returns an array of one video for an exact match" do
      video1 = Video.create(title: "Family Guy", description: "Edgy comedy")
      video2 = Video.create(title: "Family Feud", description: "Game show")
      video3 = Video.create(title: "Futurama", description: "Fry has no family")
      expect(Video.search_by_title("family guy")).to eq([video1])
    end

    it "returns an array of videos for a partial match" do
      video1 = Video.create(title: "Family Guy", description: "Edgy comedy")
      video2 = Video.create(title: "Family Feud", description: "Game show")
      video3 = Video.create(title: "Futurama", description: "Fry has no family")
      expect(Video.search_by_title("fam")).to eq([video2, video1])
    end

    it "returns an array of all matches ordered by created_at" do
      video1 = Video.create(title: "Family Guy", description: "Edgy comedy", created_at: 1.day.ago)
      video2 = Video.create(title: "Family Feud", description: "Game show")
      video3 = Video.create(title: "Futurama", description: "Fry has no family")
      expect(Video.search_by_title("fam")).to eq([video2, video1])
    end
  end

  describe "video_rating" do
    it "returns float average of all review ratings" do
      video = Fabricate(:video)
      review_1 = Fabricate(:review, video: video)
      review_2 = Fabricate(:review, video: video)
      expect(Video.first.video_rating).to eq((review_1.rating + review_2.rating).to_f / 2.to_f)
    end
  end

end
