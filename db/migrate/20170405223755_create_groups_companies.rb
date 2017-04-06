class CreateGroupsCompanies < ActiveRecord::Migration
  def change
    create_table :companies_groups do |t|
        t.integer :group_id
        t.integer :company_id
    end
  end
end
