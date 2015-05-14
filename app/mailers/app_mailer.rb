class AppMailer < ActionMailer::Base
  default from: "noreply@myflix2622.herokuapp.com"

  def notify_user_create(user)
    @user = user
    mail to: @user.email, subject: "Welcome to Myflix"
  end

  def notify_password_reset(user)
    @user = user
    mail to: @user.email, subject: "Myflix: Password Reset"
  end
end
