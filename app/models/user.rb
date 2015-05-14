class User < ActiveRecord::Base
  validates_presence_of :full_name, :email
  validates :email, uniqueness: true
  has_secure_password
  has_many :reviews, -> { order("created_at DESC") }
  has_many :queue_items, -> { order(:position) }
  has_many :followerships, foreign_key: "leader_id"
  has_many :followers, -> { order("created_at DESC") }, through: :followerships
  has_many :leaderships, class_name: "Followership", foreign_key: "follower_id"
  has_many :leaders, -> { order("created_at") }, through: :leaderships

  def queue_video(video)
    QueueItem.create(video: video, user: self, position: new_queue_item_position) unless user_queued_video?(video)
  end

  def new_queue_item_position
    queue_items.count + 1
  end

  def user_queued_video?(video)
    queue_items.map(&:video).include?(video)
  end

  def normalize_queue_item_positions
    queue_items.each_with_index do |item, index|
      item.update_attributes(position: index + 1)
    end
  end

  def followable?(leader)
    not_yet_followed?(leader) && self != leader
  end

  def not_yet_followed?(leader)
    !leaders.include?(leader)
  end

  def notify_user_create
    AppMailer.notify_user_create(self).deliver
  end

  def save_token
    self.token = SecureRandom.urlsafe_base64
    self.save
  end

  def notify_password_reset
    AppMailer.notify_password_reset(self).deliver
  end

  def update_password_and_token(password)
    self.password = password
    self.token = nil
    self.save
  end
end
