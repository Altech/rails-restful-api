class Company < ApplicationRecord
  acts_as_imageable image_names: [:avatar]

  COUNTRY_NAME_TO_CODE = {
    'japan' => 'JP',
    'singapore' => 'SG',
    'united_states' => 'US',
  }
  enum country: COUNTRY_NAME_TO_CODE
end
