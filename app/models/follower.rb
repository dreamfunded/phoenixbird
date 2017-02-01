class Follower < ActiveRecord::Base
  belongs_to :company, inverse_of: :followers
  belongs_to :user, inverse_of: :followers

  validates :company_id, :user_id, presence: true
end
