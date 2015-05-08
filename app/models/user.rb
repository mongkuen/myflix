class User < ActiveRecord::Base
  validates_presence_of :full_name, :email
  validates :email, uniqueness: true
  has_secure_password
  has_many :reviews
  has_many :queue_items, -> { order(:position) }

  def queue_video(video)
    QueueItem.create(video: video, user: self, position: new_queue_item_position) unless user_queued_video?(video)
  end

  def new_queue_item_position
    self.queue_items.count + 1
  end

  def user_queued_video?(video)
    self.queue_items.map(&:video).include?(video)
  end

  def normalize_queue_item_positions
    self.queue_items.each_with_index do |item, index|
      item.update_attributes(position: index + 1)
    end
  end
end
