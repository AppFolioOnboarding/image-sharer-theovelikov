require 'test_helper'

class ApplicationControllerTest < ActionDispatch::IntegrationTest
  test 'home' do
    get '/'
    assert_response :success
  end
  test 'images on homepage' do
    all_images = Image.all.reverse_order
    all_images.each do |image|
      get image_path(image.id)
      assert_response :success
    end
  end
end
