require 'test_helper'

class ImageTest < ActiveSupport::TestCase
  test 'empty string' do
    image = Image.new
    refute_predicate image, :valid?
  end

  test 'invalid url' do
    image = Image.new(url: 'invalid_url')
    refute_predicate image, :valid?
  end

  test 'valid url' do
    image = Image.new(url: 'https://www.humanesociety.org/sites/default/files/styles/1240x698/public/2018/08/kitten-440379.jpg?h=c8d00152&itok=1fdekAh2')
    assert_predicate image, :valid?
  end
end
