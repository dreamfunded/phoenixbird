class CreateTimelineItems < ActiveRecord::Migration
  def change
    create_table :timeline_items do |t|
        t.text :content
        t.date :created_date
        t.attachment :image
        t.integer :position

    end
  end
end
