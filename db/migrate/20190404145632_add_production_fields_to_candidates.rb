class AddProductionFieldsToCandidates < ActiveRecord::Migration[5.2]
  def change
    add_column :candidates, :production_in_formulaire, :boolean, default: false
    add_column :candidates, :production_somewhere_else, :boolean, default: false
    add_column :candidates, :production_analyzed, :boolean, default: false
  end
end
