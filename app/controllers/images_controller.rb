class ImagesController < ApplicationController

  def show
    @image = Image.find(params[:id])
  end

  def new
    @image = Image.new
  end

  def create
    @image = Image.new(image_params)

    @image.save
    redirect_to @image

  end

  private

  def image_params
    params.require(:image).permit(:url)
  end
end
