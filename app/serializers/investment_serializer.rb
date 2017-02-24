class InvestmentSerializer < ApplicationSerializer
  attributes :id, :date_invested

  belongs_to :company

  def date_invested
    @object.human_date_invested
  end
end