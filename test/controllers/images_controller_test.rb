require 'test_helper'

class ImagesControllerTest < ActionDispatch::IntegrationTest
  test 'show_test' do
    image = Image.create!(url: 'https://www.humanesociety.org/sites/default/files/styles/1240x698/public/2018/08/kitten-440379.jpg?h=c8d00152&itok=1fdekAh2')
    get image_path(image.id)
    assert_response :success
  end

  test 'create_test_valid' do
    post images_path, params: { image: { url: 'https://www.humanesociety.org/sites/default/files/styles/1240x698/public/2018/08/kitten-440379.jpg?h=c8d00152&itok=1fdekAh2' } } # rubocop:disable Metrics/LineLength
    assert_redirected_to image_path(Image.last.id)
    assert_equal Image.last.url, 'https://www.humanesociety.org/sites/default/files/styles/1240x698/public/2018/08/kitten-440379.jpg?h=c8d00152&itok=1fdekAh2'
  end

  test 'create_test_invalid' do
    post images_path, params: { image: { url: ' ' } }
    assert_response :success
    assert_template :new
  end

  test 'new_test' do
    get '/images/new'
    assert_response :success
  end

  test 'tag_list and erb_contains_tag' do
    assert_difference %w(ActsAsTaggableOn::Tag.count ActsAsTaggableOn::Tagging.count), 2 do
      assert_difference 'Image.count', 1 do
        post images_path, params: { image: { url: 'https://www.humanesociety.org/sites/default/files/styles/1240x698/public/2018/08/kitten-440379.jpg?h=c8d00152&itok=1fdekAh2', tag_list: 'Cat, Cute' } } # rubocop:disable Metrics/LineLength
        assert_redirected_to image_path(Image.last.id)
        image = Image.last
        assert_equal %w[Cat Cute], image.tag_list
        get image_path(Image.last.id)
        assert_select '.js-tags' do |tags|
          assert_equal 2, tags.length
          assert_equal 'Cat', tags[0].children.text
          assert_equal 'Cute', tags[1].children.text
        end
      end
    end
  end
  test 'empty_tag_list' do
    assert_difference %w(ActsAsTaggableOn::Tag.count ActsAsTaggableOn::Tagging.count), 0 do
      assert_difference 'Image.count', 1 do
        post images_path, params: { image: { url: 'https://www.humanesociety.org/sites/default/files/styles/1240x698/public/2018/08/kitten-440379.jpg?h=c8d00152&itok=1fdekAh2' } } # rubocop:disable Metrics/LineLength
        assert_redirected_to image_path(Image.last.id)
        image = Image.last
        assert_equal [], image.tag_list
      end
    end
  end
end
