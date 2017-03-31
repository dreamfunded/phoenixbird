class AddEmailToGroupAdmins < ActiveRecord::Migration
  def change
    add_column :group_admins, :email, :string
  end
end
