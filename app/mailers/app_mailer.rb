class AppMailer < ActionMailer::Base
  def notify_user_create(user)
    @user = user
    mail to: @user.email, from: 'noreply@myflix2622.herokuapp.com', subject: "Welcome to Myflix"
  end
end
