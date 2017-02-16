class AddAttachmentPhotoToCampaignQuotes < ActiveRecord::Migration
  def self.up
    change_table :campaign_quotes do |t|
      t.attachment :photo
    end
  end

  def self.down
    remove_attachment :campaign_quotes, :photo
  end
end
