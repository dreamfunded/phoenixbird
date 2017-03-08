class InvestmentPerk < ActiveRecord::Base
  ACCESSIBLE_ATTRIBUTES = [:id, :amount, :content]

  belongs_to :general_info, inverse_of: :investment_perks
end
