class DenormalizeSelections < ActiveRecord::Migration[5.2]
  def change
    add_column :candidates, :evaluation_selected, :boolean, default: false
    add_column :candidates, :interview_selected, :boolean, default: false
    add_column :candidates, :selection_selected, :boolean, default: false
  end
end
