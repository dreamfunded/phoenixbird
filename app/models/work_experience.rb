class WorkExperience < ActiveRecord::Base
  belongs_to :user, inverse_of: :work_experiences
  belongs_to :community_company, inverse_of: :work_experiences

  ACCESSIBLE_ATTRIBUTES = [:id, :title, :description]

  accepts_nested_attributes_for :community_company, reject_if: :all_blank, allow_destroy: true
end
