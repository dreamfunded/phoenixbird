class CreateCampaignQuotes < ActiveRecord::Migration
  def change
    create_table :campaign_quotes do |t|
      t.string :said_by
      t.string :position
      t.string :main
      t.integer :campaign_id
      t.text :description

      t.timestamps
    end
  end
end
