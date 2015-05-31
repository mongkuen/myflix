class Invite < ActiveRecord::Base
  belongs_to :user
  validates_presence_of :email

  def save_token
    self.token = SecureRandom.urlsafe_base64
    self.save
  end

  def send_invite
    AppMailer.notify_invite(self).deliver
  end
end
