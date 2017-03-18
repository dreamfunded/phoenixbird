class Education < ActiveRecord::Base
  belongs_to :user, inverse_of: :educations
  belongs_to :school, inverse_of: :educations

  ACCESSIBLE_ATTRIBUTES = [:degree_type, :major, :achievements]

  accepts_nested_attributes_for :school, reject_if: :all_blank, allow_destroy: true
end
