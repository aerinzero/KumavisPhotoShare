class ImagesController < ApplicationController

  def index
    @images = params[:ids] ? Image.where(id: params[:ids]) : Image.all
    render json: @images
  end

  def show
    @image = Image.find(params[:id])

    request.format.json? ? (render json: @image) : (send_file @image.data.path(params[:type]), type: @image.data.content_type)
  end

  def create
    @images = []

    params[:images][:files].each do |filename,file|
      image = Image.new(data:file)
      image.save

      @images.push(image)

    end

    render json: @images
  end

  def download


    "/system/:attachment/:id/:style/:filename"
    
    send_file '/home/railsway/downloads/huge.zip', :type=>"application/zip"
    send_file @download.wallpapers[1].wallpaper.url, :type => 'image/jpeg', :disposition => 'attachment'
  end

end