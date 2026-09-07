class VideosController < ApplicationController
  def new
    @video = Video.new
  end

  def create
    @video = Video.new(video_params)

    if @video.save
      redirect_to @video
    else
      render :new, status: :unprocessable_content
    end
  end

  def show
    @video = Video.find(params[:id])
  end

  private
    def video_params
      params.expect(video: [ :file ])
    end
end
