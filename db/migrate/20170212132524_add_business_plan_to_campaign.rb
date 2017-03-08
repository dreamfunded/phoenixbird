class AddBusinessPlanToCampaign < ActiveRecord::Migration
  def change
    add_column :campaigns, :business_plan, :text
  end
end
