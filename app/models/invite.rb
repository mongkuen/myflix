class Invite < ActiveRecord::Base
  include Tokenable

  belongs_to :user
  validates_presence_of :email

  def send_invite
    AppMailer.delay.notify_invite(self.id)
  end
end
