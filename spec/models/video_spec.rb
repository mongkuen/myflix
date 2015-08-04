require'spec_helper'

describe Video do
  it { should belong_to(:category) }
  it { should have_many(:reviews) }
  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:description) }
  it { should validate_presence_of(:category) }
  it { should validate_presence_of(:large_cover) }
  it { should validate_presence_of(:small_cover) }
  it { should validate_presence_of(:video_url) }

  describe "search_by_title" do
    it "returns an empty array if there is no match" do
      family_guy = Fabricate(:video, title: "Family Guy")
      family_feud = Fabricate(:video, title: "Family Feud")
      futurama = Fabricate(:video, title: "Futurama")
      expect(Video.search_by_title("Doesn't exist")).to eq([])
    end

    it "returns an array of one video for an exact match" do
      family_guy = Fabricate(:video, title: "Family Guy")
      family_feud = Fabricate(:video, title: "Family Feud")
      futurama = Fabricate(:video, title: "Futurama")
      expect(Video.search_by_title("family guy")).to eq([family_guy])
    end

    it "returns an array of videos for a partial match" do
      family_guy = Fabricate(:video, title: "Family Guy")
      family_feud = Fabricate(:video, title: "Family Feud")
      futurama = Fabricate(:video, title: "Futurama")
      expect(Video.search_by_title("fam")).to eq([family_feud, family_guy])
    end

    it "returns an array of all matches ordered by created_at" do
      family_guy = Fabricate(:video, title: "Family Guy")
      family_feud = Fabricate(:video, title: "Family Feud")
      futurama = Fabricate(:video, title: "Futurama")
      expect(Video.search_by_title("fam")).to eq([family_feud, family_guy])
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
