class AddCommpanyIdToTimelineItems < ActiveRecord::Migration
  def change
    add_column :timeline_items, :company_id, :integer
  end
end
