require 'test_helper'

class ApplicationControllerTest < ActionDispatch::IntegrationTest
  test 'home' do
    get '/'
    assert_response :success
  end
end
