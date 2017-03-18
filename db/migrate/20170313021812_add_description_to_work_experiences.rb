class AddDescriptionToWorkExperiences < ActiveRecord::Migration
  def change
    add_column :work_experiences, :description, :text
  end
end
