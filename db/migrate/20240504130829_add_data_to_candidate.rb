class AddDataToCandidate < ActiveRecord::Migration[5.2]
  def change
    add_column :candidates, :data, :jsonb
  end
end
