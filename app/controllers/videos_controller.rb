class VideosController < ApplicationController
  before_action :require_user

  def index
    @categories = Category.all
  end

  def show
    @video = Video.find(params[:id])
    @review = Review.new
  end

  def search
    @videos = Video.search_by_title(params[:search])
  end

  def review
    @video = Video.find(params[:id])
    @review = Review.new(review_params)
    @review.user = current_user
    @review.video = @video

    if @review.save
      flash[:success] = "Your review has been recorded"
      redirect_to video_path(@video)
    else
      render :show
    end
  end

  private
  def review_params
    params.require(:review).permit(:rating, :review)
  end

end
