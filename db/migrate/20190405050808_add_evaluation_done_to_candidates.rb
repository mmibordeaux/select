class AddEvaluationDoneToCandidates < ActiveRecord::Migration[5.2]
  def change
    add_column :candidates, :evaluation_done, :boolean, default: false
  end
end
