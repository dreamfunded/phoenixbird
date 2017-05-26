class AddRealEstateToCompanies < ActiveRecord::Migration
  def change
    add_column :companies, :real_estate, :boolean
  end
end
