class AddSelectionNumberOfCandidatesToSettings < ActiveRecord::Migration[5.2]
  def change
    add_column :settings, :selection_number_of_candidates, :integer
  end
end
