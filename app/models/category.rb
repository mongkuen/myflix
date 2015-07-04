class Category < ActiveRecord::Base
  has_many :videos, -> { order(created_at: :desc) }
  validates :name, presence: true

  def recent_videos
    self.videos.limit(6)
  end

  def self.selection
    Category.all.map { |category| [category.name, category.id] }
  end
end
