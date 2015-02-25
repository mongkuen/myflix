class Review < ActiveRecord::Base
  validates :rating, presence: true, inclusion: { in: [1, 2, 3, 4, 5] }
  validates :review, presence: true
  belongs_to :user
  belongs_to :video
end
