class CreateQuestions < ActiveRecord::Migration
  def change
    create_table :questions do |t|
      t.text :answer
      t.integer :company_id
      t.text :question
    end
  end
end
