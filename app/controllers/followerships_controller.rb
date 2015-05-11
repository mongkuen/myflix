class FollowershipsController < ApplicationController
  before_action :require_user

  def index
    @leaderships = current_user.leaderships
  end

  def create
    leader = User.find(params[:id])
    Followership.create(leader: leader, follower: current_user) if current_user.followable?(leader)
    redirect_to people_path
  end

  def destroy
    followership = Followership.find(params[:id])
    followership.delete if followership.follower == current_user
    redirect_to people_path
  end
end
