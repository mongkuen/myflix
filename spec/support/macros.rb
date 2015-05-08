def set_current_user(user=nil)
  set_user = user || Fabricate(:user)
  session[:user_id] = set_user.id
end

def current_user
  User.find(session[:user_id])
end

def clear_session
  session[:user_id] = nil
end
