class Admin::VideosController < AdminsController
  def new
    @video = Video.new
  end

  def create
    @video = Video.new(video_params)

    if @video.save
      flash[:success] = "Video saved successfully"
      redirect_to new_admin_video_path
    else
      flash[:danger] = "Video could not be saved"
      render :new
    end
  end

  private
  def video_params
    params.require(:video).permit(:title, :description, :category_id, :large_cover, :large_cover_cache, :small_cover)
  end
end
