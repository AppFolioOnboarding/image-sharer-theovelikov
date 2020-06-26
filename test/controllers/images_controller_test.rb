require 'test_helper'

class ImagesControllerTest < ActionDispatch::IntegrationTest
  test 'show_test' do
    image = Image.create!(url: 'https://www.humanesociety.org/sites/default/files/styles/1240x698/public/2018/08/kitten-440379.jpg?h=c8d00152&itok=1fdekAh2')
    get image_path(image.id)
    assert_response :success
    assert_select 'img', 1 do |elements|
      assert_equal 'https://www.humanesociety.org/sites/default/files/styles/1240x698/public/2018/08/kitten-440379.jpg?h=c8d00152&itok=1fdekAh2', elements[0].attributes['src'].value # rubocop:disable Metrics/LineLength
    end
  end

  test 'create_image_with_url' do
    assert_difference %w[ActsAsTaggableOn::Tag.count ActsAsTaggableOn::Tagging.count], 0 do
      assert_difference 'Image.count', 1 do
        post images_path, params: { image: { url: 'https://www.humanesociety.org/sites/default/files/styles/1240x698/public/2018/08/kitten-440379.jpg?h=c8d00152&itok=1fdekAh2' } } # rubocop:disable Metrics/LineLength
        assert_redirected_to image_path(Image.last.id)
        assert_equal Image.last.url, 'https://www.humanesociety.org/sites/default/files/styles/1240x698/public/2018/08/kitten-440379.jpg?h=c8d00152&itok=1fdekAh2'
      end
    end
  end

  test 'create_image_without_url' do
    assert_difference %w[ActsAsTaggableOn::Tag.count ActsAsTaggableOn::Tagging.count], 0 do
      assert_difference 'Image.count', 0 do
        post images_path, params: { image: { url: ' ' } }
        assert_response :success
        assert_template :new
      end
    end
  end

  test 'create image with url and tag' do
    assert_difference %w[ActsAsTaggableOn::Tag.count ActsAsTaggableOn::Tagging.count], 1 do
      assert_difference 'Image.count', 1 do
        post images_path, params: { image: { url: 'https://www.humanesociety.org/sites/default/files/styles/1240x698/public/2018/08/kitten-440379.jpg?h=c8d00152&itok=1fdekAh2', tag_list: 'Cat' } } # rubocop:disable Metrics/LineLength
        assert_redirected_to image_path(Image.last.id)
        assert_equal Image.last.url, 'https://www.humanesociety.org/sites/default/files/styles/1240x698/public/2018/08/kitten-440379.jpg?h=c8d00152&itok=1fdekAh2'
        assert_equal ['Cat'], Image.last.tag_list
      end
    end
  end

  test 'create image with empty_tag_list' do
    assert_difference %w[ActsAsTaggableOn::Tag.count ActsAsTaggableOn::Tagging.count], 0 do
      assert_difference 'Image.count', 1 do
        post images_path, params: { image: { url: 'https://www.humanesociety.org/sites/default/files/styles/1240x698/public/2018/08/kitten-440379.jpg?h=c8d00152&itok=1fdekAh2' } } # rubocop:disable Metrics/LineLength
        assert_redirected_to image_path(Image.last.id)
        image = Image.last
        assert_equal [], image.tag_list
      end
    end
  end

  test 'new renders new page' do
    get '/images/new'
    assert_response :success
    assert_template :new
  end

  test 'index renders all images ordered by creation date' do
    image1 = Image.create!(url: 'https://images.unsplash.com/photo-1494253109108-2e30c049369b?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1500&q=80', created_at: DateTime.now + 1.day) # rubocop:disable Metrics/LineLength
    image2 = Image.create!(url: 'https://images.unsplash.com/photo-1508138221679-760a23a2285b?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1267&q=80', created_at: DateTime.now - 1.day) # rubocop:disable Metrics/LineLength
    image3 = Image.create!(url: 'https://images.unsplash.com/photo-1485550409059-9afb054cada4?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=802&q=80', created_at: DateTime.now) # rubocop:disable Metrics/LineLength
    get '/images'
    assert_response :success
    assert_template :index
    assert_select 'img', 3 do |elements|
      assert_equal image1.url, elements[0].attributes['src'].value
      assert_equal image3.url, elements[1].attributes['src'].value
      assert_equal image2.url, elements[2].attributes['src'].value
    end
  end

  test 'images with associated tag appear on tagged page' do
    image1 = Image.create!(url: 'https://www.humanesociety.org/sites/default/files/styles/1240x698/public/2018/08/kitten-440379.jpg?h=c8d00152&itok=1fdekAh2', tag_list: 'Cat, Cute') # rubocop:disable Metrics/LineLength
    image2 = Image.create!(url: 'https://images.unsplash.com/photo-1508138221679-760a23a2285b?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1267&q=80', tag_list: 'Cat') # rubocop:disable Metrics/LineLength
    Image.create!(url: 'https://images.unsplash.com/photo-1485550409059-9afb054cada4?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=802&q=80', tag_list: 'Car') # rubocop:disable Metrics/LineLength
    get '/tagged?tag=Cat'
    assert_response :success
    assert_select 'img', 2 do |elements|
      assert_equal image2.url, elements[0].attributes['src'].value
      assert_equal image1.url, elements[1].attributes['src'].value
    end
  end

  test 'tag_list and erb_contains_tag' do
    assert_difference %w[ActsAsTaggableOn::Tag.count ActsAsTaggableOn::Tagging.count], 2 do
      assert_difference 'Image.count', 1 do
        image = Image.create!(url: 'https://www.humanesociety.org/sites/default/files/styles/1240x698/public/2018/08/kitten-440379.jpg?h=c8d00152&itok=1fdekAh2', tag_list: 'Cat, Cute') # rubocop:disable Metrics/LineLength
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
end
