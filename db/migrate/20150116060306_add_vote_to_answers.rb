class AddVoteToAnswers < ActiveRecord::Migration
  def change
    add_column :answers, :vote, :integer
  end
end
