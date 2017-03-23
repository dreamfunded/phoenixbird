class CreateGroupInvite < ActiveRecord::Migration
  def change
    create_table :group_invites do |t|
      t.integer :group_id
      t.string :email
      t.string :token
      t.string :name
      t.timestamps
    end
  end
end
