class CreateCommunityCompanies < ActiveRecord::Migration
  def change
    create_table :community_companies do |t|
      t.string :name

      t.timestamps
    end
  end
end
