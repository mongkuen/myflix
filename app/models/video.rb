class Video < ActiveRecord::Base
  belongs_to :category
  has_many :reviews, -> { order(created_at: :desc) }
  validates :title, presence: true
  validates :description, presence: true

  def self.search_by_title(search_str)
    return [] if search_str.blank?
    self.where("title ilike ?", "%#{search_str}%").order("created_at DESC")
  end

  def video_rating
    rating_sum = 0
    self.reviews.each do |review|
      rating_sum += review.rating
    end
    rating_sum.to_f / self.reviews.count.to_f
  end
end
