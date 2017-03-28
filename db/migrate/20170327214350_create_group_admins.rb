class CreateGroupAdmins < ActiveRecord::Migration
  def change
    create_table :group_admins do |t|
      t.string :name
      t.text :bio
      t.integer :group_id
      t.integer :user_id
      t.attachment :photo
    end
  end
end
