class AddGlobalPositionToCandidates < ActiveRecord::Migration[5.2]
  def change
    add_column :candidates, :global_position, :integer
  end
end
