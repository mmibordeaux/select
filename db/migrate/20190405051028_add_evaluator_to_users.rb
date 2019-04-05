class AddEvaluatorToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :evaluator, :boolean
  end
end
