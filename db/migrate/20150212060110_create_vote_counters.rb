class CreateVoteCounters < ActiveRecord::Migration
  def change
    create_table :vote_counters do |t|
    	t.integer :user_id
    	t.integer :answer_id
    	t.string :action
      	t.timestamps null: false
    end
    add_index(:vote_counters, [:user_id, :answer_id])
  end
end
