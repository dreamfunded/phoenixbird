class AddSlugToMembers < ActiveRecord::Migration
  def change
    add_column :members, :slug, :string
    add_index  :members, :slug
  end
end
