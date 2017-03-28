class ChangeGroupMembersName < ActiveRecord::Migration
  def change
    rename_column :groups, :members, :member
  end
end
