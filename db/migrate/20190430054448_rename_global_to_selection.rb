class RenameGlobalToSelection < ActiveRecord::Migration[5.2]
  def change
    rename_column :candidates, :global_note, :selection_note
    rename_column :candidates, :global_position, :selection_position
  end
end
