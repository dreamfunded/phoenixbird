class CreateWorkExperiences < ActiveRecord::Migration
  def change
    create_table :work_experiences do |t|
      t.references :community_company
      t.references :user
      t.string :title
      t.date :date_start
      t.date :date_end
      t.boolean :present

      t.timestamps
    end
  end
end
