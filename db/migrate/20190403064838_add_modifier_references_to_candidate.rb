class AddModifierReferencesToCandidate < ActiveRecord::Migration[5.2]
  def change
    change_table(:candidates) do |t|
      t.references :attitude
      t.references :intention
      t.references :production
      t.references :localization
    end
    remove_column :candidates, :evaluation_attitude
    remove_column :candidates, :evaluation_intention
    remove_column :candidates, :evaluation_production
    remove_column :candidates, :evaluation_localization
  end
end
