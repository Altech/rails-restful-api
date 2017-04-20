# == Schema Information
#
# Table name: companies
#
#  id               :integer          not null, primary key
#  name             :string
#  founded_on       :date
#  url              :string
#  origin           :text
#  why_description  :text
#  what_description :text
#  how_description  :text
#  country          :string(2)        default("JP"), not null
#  created_at       :datetime
#  updated_at       :datetime
#

class Company < ApplicationRecord
  acts_as_imageable image_names: [:avatar]

  COUNTRY_NAME_TO_CODE = {
    'japan' => 'JP',
    'singapore' => 'SG',
    'united_states' => 'US',
  }
  enum country: COUNTRY_NAME_TO_CODE

  has_many :jobs
  has_many :employees, through: :jobs, source: :user

  require 'uri'

  def domain
    if url
      URI.parse(url).host
    end
  rescue URI::InvalidURIError
    nil
  end
end
