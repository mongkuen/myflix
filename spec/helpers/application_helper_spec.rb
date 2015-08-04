require 'spec_helper'

describe ApplicationHelper do
  describe "#rating_rounding" do
    it "returns 0.0 if no rating" do
      rating = 0.0/0.0
      expect(rating_rounding(rating)).to eq(0.0)
    end

    it "returns rounded number if rating exists" do
      rating = 3.9/5
      expect(rating_rounding(rating)).to eq(0.8)
    end
  end

  describe "#category_selection" do
    it "returns empty array if there are no categories" do
      expect(category_selection).to eq([])
    end

    it "returns all categories with their ids" do
      category_1 = Fabricate(:category)
      category_2 = Fabricate(:category)
      expect(category_selection).to eq([[category_1.name, category_1.id], [category_2.name, category_2.id]])
    end
  end
end
