class AddCompanyIdToCampaignQuotes < ActiveRecord::Migration
  def change
    add_column :campaign_quotes, :company_id, :integer
  end
end
