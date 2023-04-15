class AddBoostToEvaluation < ActiveRecord::Migration[5.2]
  def change
    add_column :evaluations, :boost, :boolean, default: false
  end
end
