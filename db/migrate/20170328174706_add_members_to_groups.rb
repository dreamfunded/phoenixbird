class AddMembersToGroups < ActiveRecord::Migration
  def change
    add_column :groups, :members, :integer
  end
end
