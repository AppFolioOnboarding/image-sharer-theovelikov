require 'acts-as-taggable-on'

class Image < ApplicationRecord
  acts_as_taggable_on :tags
  validates :url, presence: true
  validates :url, url: { allow_blank: false }
end
