# == Schema Information
#
# Table name: users
#
#  id      :integer          not null, primary key
#  name_en :string(64)
#  name_ja :string(64)
#  score   :integer          default("0")
#

class User < ApplicationRecord
  acts_as_imageable image_names: [:avatar]

  def name
    case I18n.locale
    when :en
      name_en || name_ja
    when :ja
      name_ja || name_en
    else
      name_ja || name_en
    end
  end
end
