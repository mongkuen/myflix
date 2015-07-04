def set_current_user(user=nil)
  set_user = user || Fabricate(:user)
  session[:user_id] = set_user.id
end

def set_admin(admin=nil)
  set_admin = admin || Fabricate(:admin)
  session[:user_id] = set_admin.id
end

def current_user
  User.find(session[:user_id])
end

def clear_session
  session[:user_id] = nil
end

def log_in(user=nil)
  log_in_user = user || Fabricate(:user)
  visit '/login'
  fill_in "Email Address", with: log_in_user.email
  fill_in "Password", with: log_in_user.password
  click_on "Sign In"
end

def clear_mailer
  ActionMailer::Base.deliveries.clear
end
