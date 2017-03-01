class AddWebsitesFieldToUsers < ActiveRecord::Migration
  def change
    add_column :users, :websites, :text
  end
end
