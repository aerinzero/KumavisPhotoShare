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

end