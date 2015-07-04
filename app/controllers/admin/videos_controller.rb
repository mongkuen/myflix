class Admin::VideosController < AdminsController
  def new
    @video = Video.new
  end

  def create
    @video = Video.new(video_params)
    @video.large_cover_url = params[:file]
    @video.large_cover_url = File.open("public/tmp")

    if @video.save
      redirect_to root_path
    else
      render :new
    end
  end

  private
  def video_params
    params.require(:video).permit(:title, :description, :category_id, :large_cover_url)
  end
end
