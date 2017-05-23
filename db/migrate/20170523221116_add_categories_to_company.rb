class AddCategoriesToCompany < ActiveRecord::Migration
  def change
    add_column :companies, :categories, :string
  end
end
