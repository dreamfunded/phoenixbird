class CreateEducations < ActiveRecord::Migration
  def change
    create_table :educations do |t|
      t.references :user
      t.references :school
      t.string :degree_type
      t.string :major
      t.text :achievements
      t.integer :graduated_year
      t.integer :graduated_month

      t.timestamps
    end
  end
end
