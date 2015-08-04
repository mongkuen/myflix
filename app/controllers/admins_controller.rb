class AdminsController < ApplicationController
  before_filter :require_user
  before_filter :require_admin

  def require_admin
    unless current_user.is_admin?
      flash[:danger] = "You do not have access to that page."
      redirect_to root_path unless current_user.is_admin?
    end
  end
end
