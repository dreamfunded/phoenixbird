class AddRegAToCompanies < ActiveRecord::Migration
  def change
    add_column :companies, :reg_a, :boolean
  end
end
