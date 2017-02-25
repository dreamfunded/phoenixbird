class AddInfoFieldsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :aspirations, :text
    add_column :users, :achievements, :text
    add_column :users, :looking_for, :text
  end
end
