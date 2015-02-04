class CreateQuestions < ActiveRecord::Migration
  def change
    create_table :questions do |t|
      t.text :title
      t.integer :user_id
      t.text :description
      t.timestamps 
    end
    add_index(:questions, :user_id)
  end
end
