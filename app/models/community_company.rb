class CommunityCompany < ActiveRecord::Base
  has_many :work_experiences, inverse_of: :community_company
  has_many :users, through: :work_experiences

  ACCESSIBLE_ATTRIBUTES = [:name]
end
