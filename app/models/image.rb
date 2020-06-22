class Image < ApplicationRecord
  validates :url, presence: true
  validates :url, url: {allow_blank: false}

end
