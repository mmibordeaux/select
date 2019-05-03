class AddDecilesToCandidates < ActiveRecord::Migration[5.2]
  def change
    add_column :candidates, :evaluation_decile, :integer
    add_column :candidates, :selected_for_interview_decile, :integer
    add_column :candidates, :interview_decile, :integer
  end
end
