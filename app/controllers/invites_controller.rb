class InvitesController < ApplicationController
  before_action :require_user, :new

  def new
    @invite = Invite.new
  end

  def create
    @invite = Invite.new(invite_params)
    @invite.user = current_user

    if @invite.save
      @invite.generate_token
      @invite.send_invite
      flash[:success] = "Your invitation was sent!"
      redirect_to invites_path
    else
      flash[:danger] = "Invitation must have an email!"
      render :new
    end
  end

  private
  def invite_params
    params.require(:invite).permit(:name, :email, :message)
  end
end
