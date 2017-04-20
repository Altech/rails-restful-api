class CompanySerializer < ApplicationSerializer
  attributes :id, :name, :url
  attributes :origin, :why_description, :what_description, :how_description
  attributes :domain
end
