class AddNoteToEvaluations < ActiveRecord::Migration[5.2]
  def change
    add_column :evaluations, :note, :float
  end
end
