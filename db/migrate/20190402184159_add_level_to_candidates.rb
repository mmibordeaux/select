class AddLevelToCandidates < ActiveRecord::Migration[5.2]
  def change
    add_column :candidates, :level, :text
  end
end
