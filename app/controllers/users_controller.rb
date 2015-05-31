class UsersController < ApplicationController
  before_action :home_redirect_if_authenticated, only: [:new, :create]
  before_action :require_user, only: [:show]

  def new
    if params[:token]
      invite = Invite.find_by_token(params[:token])
      @user = User.new(email: invite.email, full_name: invite.name)
    else
      @user = User.new
    end
  end

  def create
    @user = User.new(user_params)

    if @user.save
      @user.connect_with_invitors
      @user.notify_user_create
      session[:user_id] = @user.id
      redirect_to root_path
    else
      render :new
    end
  end

  def show
    @user = User.find(params[:id])
  end

  private
  def user_params
    params.require(:user).permit(:email, :password, :full_name)
  end
end
