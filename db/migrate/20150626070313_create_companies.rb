class CreateCompanies < ActiveRecord::Migration
  def change
    create_table :companies do |t|
    	t.column :user_id,:string
    	t.column :name,:string
    	t.column :description,:text
    	t.column :image_file_name, :string
    	t.column :invested_amount, :integer
        t.column :website_link, :string
        t.column :video_link, :string
        t.column :goal_amount, :integer
        t.column :status, :integer
        
        t.column :CEO, :string
        t.column :CEO_number, :string
        t.column :display, :integer
        t.column :days_left, :integer

    	t.timestamps
    end
  end
end
