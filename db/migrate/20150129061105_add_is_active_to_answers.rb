class AddIsActiveToAnswers < ActiveRecord::Migration
  def change
    add_column :answers, :is_active, :boolean, default: true
  end
end
