class AddEvaluationsToCandidates < ActiveRecord::Migration[5.2]
  def change
    add_column :candidates, :evaluations_count, :integer, default: 0
  end
end
