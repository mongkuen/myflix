class PasswordResetsController < ApplicationController
  before_action :home_redirect_if_authenticated

  def new; end

  def create
    user = User.find_by(email: params[:email])
    if user
      user.generate_token
      user.notify_password_reset
      redirect_to confirmation_path
    else
      flash[:danger] = "That email is not valid, please try again."
      redirect_to forgot_password_path
    end
  end

  def confirmation; end

  def edit
    @user = User.find_by_token(params[:id])
    redirect_to token_expired_path unless @user
  end

  def token_expired; end

  def update
    user = User.find_by_token(params[:token])
    if user
      user.update_password_and_token(params[:password])
      flash[:success] = "You can now login with your new password"
      redirect_to login_path
    else
      redirect_to token_expired_path
    end
  end
end
