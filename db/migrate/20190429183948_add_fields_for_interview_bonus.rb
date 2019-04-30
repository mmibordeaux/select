class AddFieldsForInterviewBonus < ActiveRecord::Migration[5.2]
  def change
    add_column :candidates, :interview_bonus, :boolean, default: false
    add_column :candidates, :global_note, :float
    add_column :settings, :interview_bonus, :float
  end
end
