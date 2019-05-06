class RenameDeciles < ActiveRecord::Migration[5.2]
  def change
    rename_column :candidates, :interview_decile, :selection_decile
    rename_column :candidates, :selected_for_interview_decile, :interview_decile
  end
end
