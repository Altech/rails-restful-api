class ImageSerializer < ApplicationSerializer
  attributes :url
  attribute(:width) { object.file_width }
  attribute(:height) { object.file_height }
end
