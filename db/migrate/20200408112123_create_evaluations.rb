class CreateEvaluations < ActiveRecord::Migration[5.2]
  def change
    create_table :evaluations do |t|
      t.references :candidate, foreign_key: true
      t.references :user, foreign_key: true
      t.references :attitude, foreign_key: {to_table: :modifiers}
      t.references :intention, foreign_key: {to_table: :modifiers}
      t.references :production, foreign_key: {to_table: :modifiers}
      t.references :localization, foreign_key: {to_table: :modifiers}
      t.string :comment

      t.timestamps
    end

    remove_column :candidates, :attitude_id
    remove_column :candidates, :intention_id
    remove_column :candidates, :production_id
    remove_column :candidates, :localization_id
    remove_column :candidates, :evaluated_by_id
    remove_column :candidates, :attributed_to_id
  end
end
