class CampaignQuote < ActiveRecord::Base
  belongs_to :campaign
  validates :said_by, :main, presence: true
end
