# == Schema Information
#
# Table name: jobs
#
#  id         :integer          not null, primary key
#  user_id    :integer          not null
#  company_id :integer          not null
#  created_at :datetime
#  updated_at :datetime
#

class Job < ApplicationRecord
  belongs_to :user
  belongs_to :company
end
