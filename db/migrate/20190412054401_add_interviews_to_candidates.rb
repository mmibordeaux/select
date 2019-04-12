class AddInterviewsToCandidates < ActiveRecord::Migration[5.2]
  def change
    add_column :candidates, :interview_done, :boolean, default: false
    add_column :candidates, :interview_comment, :text
    add_column :candidates, :interview_position, :integer
    add_column :candidates, :interview_note, :float
    add_column :candidates, :interview_knowledge_id, :integer
    add_column :candidates, :interview_project_id, :integer
    add_column :candidates, :interview_motivation_id, :integer
    add_column :candidates, :interview_culture_id, :integer
    add_column :candidates, :interview_argument_id, :integer
  end
end
