class CreateAnswers < ActiveRecord::Migration
  def change
    create_table :answers do |t|
      t.text :feedback
      t.integer :question_id
      t.integer :user_id
      t.timestamps
    end
    add_index(:answers, [:question_id, :user_id])
  end
end
