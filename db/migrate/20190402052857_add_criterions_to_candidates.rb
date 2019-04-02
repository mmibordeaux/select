class AddCriterionsToCandidates < ActiveRecord::Migration[5.2]
  def change
    change_table(:candidates) do |t|
      t.float :dossier_note, default: 0.0
      t.float :evaluation_attitude, default: 0.0
      t.float :evaluation_intention, default: 0.0
      t.float :evaluation_production, default: 0.0
      t.float :evaluation_localization, default: 0.0
      t.float :evaluation_note, default: 0.0
      t.text :evaluation_comment, default: ''
      t.references :evaluated_by, foreign_key: { to_table: :users }
    end
  end
end
