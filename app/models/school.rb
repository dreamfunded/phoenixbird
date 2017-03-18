class School < ActiveRecord::Base
  has_many :educations, inverse_of: :school
  has_many :students, through: :educations

  ACCESSIBLE_ATTRIBUTES = [:name]
end
