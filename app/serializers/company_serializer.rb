class CompanySerializer < ApplicationSerializer
  attributes :id, :name, :url
  attributes :origin, :why_description, :what_description, :how_description
  attributes :domain

  has_one :avatar

  preload do
    association :avatar
  end
end
