class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  def home
    @all_images = Image.all.reverse_order
  end
end
