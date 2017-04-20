# == Schema Information
#
# Table name: images
#
#  id             :integer          not null, primary key
#  name           :string           default("image"), not null
#  imageable_id   :integer
#  imageable_type :string
#  url            :string
#  file_width     :integer
#  file_height    :integer
#

class Image < ApplicationRecord
  belongs_to :imageable, polymorphic: true
end
