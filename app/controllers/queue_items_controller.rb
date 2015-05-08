class QueueItemsController < ApplicationController
  before_action :require_user

  def index
    @queue_items = current_user.queue_items
  end

  def create
    video = Video.find(params[:video_id])
    current_user.queue_video(video)
    redirect_to my_queue_path
  end

  def destroy
    queue_item = QueueItem.find(params[:id])
    queue_item.destroy if current_user.queue_items.include?(queue_item)
    current_user.normalize_queue_item_positions
    redirect_to my_queue_path
  end

  def update
    begin
      update_queue_items
      current_user.normalize_queue_item_positions
    rescue ActiveRecord::RecordInvalid
      flash[:danger] = "Invalid position"
    end
    redirect_to my_queue_path
  end

  private
  def update_queue_items
    ActiveRecord::Base.transaction do
      params[:queue_items].each do |item|
        queue_item = QueueItem.find(item[:id])
        queue_item.update_attributes!(position: item[:position]) if queue_item.user == current_user
      end
    end
  end
end
