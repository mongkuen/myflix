class Video < ActiveRecord::Base
  belongs_to :category
  validates :title, presence: true
  validates :description, presence: true

  def self.search_by_title(search_str)
    return [] if search_str.blank?
    self.where("title ilike ?", "%#{search_str}%").order("created_at DESC")
  end
end
