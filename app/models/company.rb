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
