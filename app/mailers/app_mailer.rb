class AppMailer < ActionMailer::Base
  default from: "noreply@myflix2622.herokuapp.com"

  def notify_user_create(user_id)
    @user = User.find(user_id)
    mail to: @user.email, subject: "Welcome to Myflix"
  end

  def notify_password_reset(user_id)
    @user = User.find(user_id)
    mail to: @user.email, subject: "Myflix: Password Reset"
  end

  def notify_invite(invite_id)
    @invite = Invite.find(invite_id)
    mail to: @invite.email, subject: "You're invited!"
  end
end
