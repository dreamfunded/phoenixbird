class AddEntityToUsers < ActiveRecord::Migration
  def change
    add_column :users, :entity_id, :string
    add_column :users, :ach_id, :string
  end
end
